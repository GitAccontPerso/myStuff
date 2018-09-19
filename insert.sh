rm -f buffer
mosquitto_pub -h localhost -t /$1/tty -m 'file.remove("buffer")'
socat -d -d -d -U TCP4-LISTEN:3334,reuseaddr OPEN:$2 &

echo "ecriture de $2 dans buffer"
mosquitto_pub -h localhost -t /$1/sctw -m "buffer"
