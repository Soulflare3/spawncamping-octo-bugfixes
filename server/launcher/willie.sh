#! /bin/sh
#test -f willie || exit 0
case "$1" in
        start)
                echo -n "Stopping running copy of Willie, if applicable \n"
                pkill -x willie
                screen -R willie -X quit
                echo -n "Starting Willie \n"
                screen -dmS willie sh /home/scripts/startwillie.sh
                #screen -S willie -X stuff "willie"
                #screen -r willie -X stuff willie $'ls\n'
                exit 1
                ;;
        stop)
                echo -n "Stopping Willie \n"
                pkill -x willie
                screen -R willie -X quit
                exit 1
                ;;
        *)
                echo "Usage: willie.sh start|stop"
                exit 1
                ;;
        esac