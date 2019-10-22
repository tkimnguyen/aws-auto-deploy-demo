This is demo code for Kim Nguyen's [Deploying Plone on Amazon AWS](https://2019.ploneconf.org/talks/deploying-plone-on-amazon-aws/) talk 

- Terraform will deploy a virtual private cloud, a Salt master, and an EC2 instance to be used for a Plone website.
- Saltstack will configure the servers and deploy the Plone website

To try this with Vagrant:
- Install [VirtualBox](https://www.virtualbox.org)
- Install [Vagrant](https://www.vagrantup.com)
- `cd saltstack`
- `vagrant up`

To try this with Amazon AWS:

- Create an AWS account
- Create an AWS user, e.g. `Administrator`
- Create an AWS group, e.g. `Administrators`
- [Create a new key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#how-to-generate-your-own-key-and-import-it-to-aws) called `cloud-conf-demo` for that user 
- Import your ssh public key into the new key pair
- `cd terraform`
- `terraform init`
- `terraform apply`
- `terraform state pull aws_instance |egrep '"name"|public_ip"'` and look for the IP address associated with "demo_servers".

You should be able to `ssh -L8080:localhost:8080 ubuntu@34.239.125.159`. If you see an ssh authenticity warning, e.g.

    The authenticity of host '34.239.125.159 (34.239.125.159)' can't be established.
    ECDSA key fingerprint is SHA256:TJQ6hLvJG6fmTFR+epRYsqHzXpfrz1nQWRZcpdJGQ2k.
    Are you sure you want to continue connecting (yes/no)? 
    
Type `yes` then press Enter.

Once you are ssh'd to the server, you can view the output of the userdata script which set up salt and the static web site:

    less /var/log/cloud-init-output.log

or 

    tail -f /var/log/cloud-init-output.log
    
Once Plone has finished building, open a browser and visit [http://localhost:8080](http://localhost:8080) to view your new Plone installation.

You should also be able to view the two new EC2 instances in your AWS EC2 console. One will be the salt master and the other is the demo server running the static website.

Other useful Terraform commands: 

- `terraform destroy` to destroy/remove everything you created above from AWS (don't leave anything running or it may cost you real money)
- `terraform validate` to check for errors     


