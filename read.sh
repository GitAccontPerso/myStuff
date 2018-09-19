# usage  read module fichier <dest>

mosquitto_pub -h localhost -t /$1/sctr -m ''$(basename $2)''
if [ $# = "2" ]
then
	socat -v -d -d -U OPEN:$2,create TCP4-LISTEN:3335,reuseaddr
else
	socat -v -d -d -d -d -U OPEN:$3,create TCP4-LISTEN:3335,reuseaddr
fi




