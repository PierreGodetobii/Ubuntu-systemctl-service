#!/bin/sh                                                                                                         
while true                                                                                                        
do                                                                                                                
dates=$( date +"%T" )                                                                                             
addr1=$( echo "192.168.1.170" )                                                                                   
addr2=$( echo "192.168.1.131")                                                                                    
user1=$( nmap -sn $addr1 | egrep "scan report" | cut -d '(' -f2 | cut -d ')' -f1 )                                
user2=$( nmap -sn $addr2 | egrep "scan report" | cut -d '(' -f2 | cut -d ')' -f1 )                                
user1out=$(echo $user1)                                                                                           
user2out=$(echo $user2)                                                                                           
echo "$dates user1 is $user1out" | sudo tee -a /var/log/screen.log                                                
echo "$dates user2 is $user2out" | sudo tee -a /var/log/screen.log                                                
on=$( vcgencmd display_power )                                                                                    
temp=$( vcgencmd measure_temp )                                                                                   
echo "$dates Checking temp $temp" | sudo tee -a /var/log/screen.log                                               
 ##### Check if user1 is home ####                                                                                
if [ "$user1out" = "$addr1" ]                                                                                     
then                                                                                                              
    ###ok check screen is on###                                                                                   
    if [ "$on" = "display_power=1" ]                                                                              
    then                                                                                                          
    echo "$dates screen is on for user1 $addr1" | sudo tee -a /var/log/screen.log                                 
    sleep 15                                                                                                      
    exit                                                                                                          
    else                                                                                                          
    echo "$dates screen is off for $addr1 , but user is home. turning on screen" | sudo tee -a /var/log/screen.log
    vcgencmd display_power 1 2                                                                                    
    sleep 15                                                                                                      
    exit                                                                                                          
    fi                                                                                                            
else                                                                                                              
##user don't seem to be home, lets check again in 5 sec                                                           
sleep 5                                                                                                           
if ! ping -c 2 -i 3 $addr1                                                                                        
then                                                                                                              
## user is not home ##                                                                                            
sleep 5                                                                                                           
## Lets check if user 2 is home ##                                                                                
 if [ "$user2out" = "$addr2" ]                                                                                    
 then                                                                                                             
 ### user2 is home ###                                                                                            
    ###ok check screen is on###                                                                                   
    on=$( vcgencmd display_power )                                                                                
    if [ "$on" = "display_power=1" ]                                                                              
    then                                                                                                          
    echo "$dates screen is on for user2 $addr2" | sudo tee -a /var/log/screen.log                                 
    sleep 15                                                                                                      
    exit                                                                                                          
    else                                                                                                          
    echo "$dates screen is off for $addr2 , but user is home. turning on screen" | sudo tee -a /var/log/screen.log
    vcgencmd display_power 1 2                                                                                    
    sleep 15                                                                                                      
    exit                                                                                                          
    fi                                                                                                            
else                                                                                                              
### user2 seems not to be home ###                                                                                
    ##user don't seem to be home, lets check again in 5 sec                                                       
    sleep 5                                                                                                       
    if ! ping -c 2 -i 3 $addr2                                                                                    
    then                                                                                                          
    echo "$dates no ping response, turning off screen now" | sudo tee -a /var/log/screen.log                      
    ### checking if screen already is off ###                                                                     
        if [ "$on" = "display_power=0" ]                                                                          
        then                                                                                                      
        echo "$dates screen is off for all users" | sudo tee -a /var/log/screen.log                               
        exit                                                                                                      
        else                                                                                                      
        echo "$dates Turning off screen for all users" | sudo tee -a /var/log/screen.log                          
        vcgencmd display_power 0 2                                                                                
        sleep 15                                                                                                  
        exit                                                                                                      
        fi                                                                                                        
    fi                                                                                                            
  fi                                                                                                              
fi                                                                                                                
fi                                                                                                                
done                                                                                                              
