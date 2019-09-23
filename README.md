# AWS Auto Website Deployment

Serves as a demo for Matt Carlton's `"Deploying Services to AWS Without Leaving the Comfort of your Desktop" talk <https://github.com/IndyAWS/IndyAWS-Presentations/tree/master/2019/05%20-%20May%20-%20Matt%20Carlton%20-%20Deploying%20Services%20to%20AWS%20Without%20Leaving%20The%20Comfort%20Of%20Your%20Desktop>`_.

- Terraform will deploy a VPC, a salt master, and a ec2 instance to be used for a static website.
- Saltstack will configure the servers and deploy the static website
- static-source is a mkdocs project to generate the static site used in the demo
- static-html is the generated static site
- enhanced to deploy a Plone site

To try this with Vagrant:
- Install `VirtualBox <https://www.virtualbox.org/>`_
- Install `Vagrant <https://www.vagrantup.com>`_
- `cd saltstack`
- `vagrant up`

To try this with Amazon AWS:

- Create an AWS account
- Create an AWS user, e.g. `Administrator`
- Create an AWS group, e.g. `Administrators`
- Create a new key pair for that user called `cloud-conf-demo`
- Import your ssh public key into the new key pair
- `cd terraform`
- `terraform init`
- `terraform apply`
- `terraform state pull aws_instance |egrep '"name"|public_ip"'` and look for the IP address associated with "demo_servers".

Open a browser and navigate to that IP address, e.g. if you see

          "name": "demo_servers",
            "public_ip": "34.239.125.159",

you should be able to browse to `http://34.239.125.159` and see a web page like this:

  .. image:: https://github.com/tkimnguyen/aws-auto-deploy-demo/raw/master/Screen%20Shot%202019-09-23%20at%203.29.00%20PM.png

You should also be able to `ssh ubuntu@34.239.125.159`. If you see an ssh authenticity warning, e.g.

    The authenticity of host '34.239.125.159 (34.239.125.159)' can't be established.
    ECDSA key fingerprint is SHA256:TJQ6hLvJG6fmTFR+epRYsqHzXpfrz1nQWRZcpdJGQ2k.
    Are you sure you want to continue connecting (yes/no)? 
    
Type `yes` then press Enter.

Once you are ssh'd to the server, you can view the output of the userdata script which set up salt and the static web site:

    less /var/log/cloud-init-output.log

or 

    tail -f /var/log/cloud-init-output.log

You should also be able to view the two new EC2 instances in your AWS EC2 console. One will be the salt master and the other is the demo server running the static website.

Other useful Terraform commands: 

- `terraform destroy` to destroy/remove everything you created above from AWS (don't leave anything running or it may cost you real money)
- `terraform validate` to check for errors     


