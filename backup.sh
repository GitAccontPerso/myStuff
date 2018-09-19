rm ./dir
mosquitto_pub -h localhost -t /$1/tty -m 'dofile("filelist.lua")'
sleep 1
mosquitto_pub -h localhost -t /$1/sctr -m 'dir'
socat -v -d -U OPEN:dir,create TCP4-LISTEN:3335,reuseaddr

list=`cut -d ':' -f 1 dir`
for f in $list 
do
#	sleep 1
	echo " ##################   Fichier: $f"
	mosquitto_pub -h localhost -t /$1/sctr -m "$f"
	socat -d -U OPEN:./$1/backup/$f,create TCP4-LISTEN:3335,reuseaddr
done



