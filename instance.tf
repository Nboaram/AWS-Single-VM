resource "aws_instance" "default" {
  # ubuntu 18.04
  ami = "ami-0c30afcb7ab02233d"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.default.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  associate_public_ip_address = true
  key_name = "default-key-pair"
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
    inline = [
      "install git",
      "git clone https://github.com/nboaram/Docker-ComposeSetup",
      "./Docker-ComposeSetup/docker-composeInstall.sh",
      "sudo docker network create pool-app",
      "sudo docker run -d --network pool-app --name database -p27017:27017 mongo",
      "sudo docker run -d --network pool-app --name api -p 8080:8080 nboaram/api",
      "sudo docker run -d --network pool-app --name ui -p 80:80 nboaram/ui"
    ]
  }
}