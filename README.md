# sshautomate
autologin your server when you use jumpers

# Usage
1. you need to install shyml: [shyaml](https://github.com/0k/shyaml)
2. download automate.sh and session.yaml
3. edit session.yaml,filling your jumper info and server info
4. run: ./automate.sh myserver

# Support MFA 

- support google MFA
- you need to clone the repo: [google-authenticator](https://github.com/grahammitchell/google-authenticator) and modify the secret.json file which contain your MFA factor and user name
- when you have content in sessdion.yaml

```
my_jump:
  sshlogin: "ssh -p 2222 root@myjumpserverip"
  automate:
    - {expect: OTP, send: ""}
```
automate.sh will calculate the OTP code and send to the jump server
