#!/bin/sh                                                                                                         
while true                                                                                                        
do                                                                                                                
dates=$( date +"%T" )                                                                                             
addr1=$( echo "192.168.1.170" )                                                                                   
addr2=$( echo "192.168.1.131")                                                                                    
user1=$( nmap -sn $addr1 | egrep "scan report" | awk '{print $6}' | cut -d ')' -f1 | cut -d '(' -f2 )             
user2=$( nmap -sn $addr2 | egrep "scan report" | awk '{print $6}' | cut -d ')' -f1 | cut -d '(' -f2 )             
user1out=$(echo $user1)                                                                                           
user2out=$(echo $user2)                                                                                           
on=$( vcgencmd display_power )                                                                                    
if [ "$user1out" = "$addr1" ]                                                                                     
then                                                                                                              
  if [ "$on" = "display_power=1" ]                                                                                
  then                                                                                                            
  echo "$dates screen is on for $addr1" | sudo tee -a /var/log/screen.log                                         
  sleep 10                                                                                                        
  exit                                                                                                            
  else                                                                                                            
  echo "$dates screen is off for $addr1 , but user is home. turning on screen" | sudo tee -a /var/log/screen.log  
  vcgencmd display_power 1 2                                                                                      
  sleep 10                                                                                                        
  exit                                                                                                            
  fi                                                                                                              
else                                                                                                              
echo "$dates user $addr1 is not home. checking for $addr2 .." | sudo tee -a /var/log/screen.log                   
    if [ "$user2out" = "$addr2" ]                                                                                 
    then                                                                                                          
      if [ "$on" = "display_power=1" ]                                                                            
      then                                                                                                        
      echo "$dates screen is on for $addr2" | sudo tee -a /var/log/screen.log                                     
      sleep 10                                                                                                    
      exit                                                                                                        
      else                                                                                                        
      echo "$dates screen is off for $addr2 but user is home. turning on screen" | sudo tee -a /var/log/screen.log
      vcgencmd display_power 1 2                                                                                  
      sleep 10                                                                                                    
      exit                                                                                                        
      fi                                                                                                          
    else                                                                                                          
    echo "$dates no users are home. testing again..." | sudo tee -a /var/log/screen.log                           
      if [ "$on" = "display_power=0" ]                                                                            
      then                                                                                                        
      echo "$dates Screen is already off" | sudo tee -a /var/log/screen.log                                       
      sleep 10                                                                                                    
      exit                                                                                                        
      else                                                                                                        
      sleep 10                                                                                                    
      if ! ping -c 3 $addr1 && ping -c 3 $addr2                                                                   
      then                                                                                                        
      echo "$dates no ping response, turning off screen now" | sudo tee -a /var/log/screen.log                    
      vcgencmd display_power 0 2                                                                                  
      sleep 10                                                                                                    
      exit                                                                                                        
      else echo "$dates nmap failed but ping responded." | sudo tee -a /var/log/screen.log                        
      sleep 10                                                                                                    
      exit                                                                                                        
      fi                                                                                                          
      fi                                                                                                          
fi                                                                                                                
sleep 10                                                                                                          
fi                                                                                                                
done                                                                                                              
