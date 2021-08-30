delay=2

while true
do

for i in $(sudo arp -n | grep -v "address" -i | grep -v -i "eth" | tr -s " " | cut -d " " -f 3 | sort | uniq -c | tr -s " " | cut -d " " -f 2)
do
echo "DEBUG: Performing check..."
delay=2
if [ $i -ne 1 ]
then
delay=11
echo "Number of same etries: $i"
echo "arp cache poisoning attack detected"
notify-send "WARNING!" "arp cache poisoning attack detected"
fi
done

sleep $delay
done
