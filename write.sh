rm -f buffer
mosquitto_pub -h localhost -t /$1/tty -m 'file.remove("buffer")'

echo "######## ecriture de $2 dans buffer"
mosquitto_pub -h localhost -t /$1/sctw -m "buffer"
socat -d -d -U TCP4-LISTEN:3335,reuseaddr OPEN:$2

echo "######## verification de buffer"
sleep 1
mosquitto_pub -h localhost -t /$1/sctr -m 'buffer'
socat -d -d -U OPEN:buffer,create TCP4-LISTEN:3335,reuseaddr


echo "######## diff : $2 - buffer"
diff= `diff $2 ./buffer`
if  diff  "$2" "./buffer" ;
then
	echo "######## pas de diff ! on continue !"
	mosquitto_pub -h localhost -t /$1/tty -m 'file.remove("'$(basename $2)'")'
	sleep 1
	mosquitto_pub -h localhost -t /$1/tty -m 'file.rename("buffer","'$(basename $2)'")'
	mosquitto_pub -h localhost -t /$1/tty -m 'node.restart()'

else
	echo "######## erreur de trans ! on stoppe !"
fi
