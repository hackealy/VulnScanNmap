#!/bin/bash

# Obtém o endereço IP da interface de rede
ip=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Executa o scan com o Nmap e armazena o resultado em um arquivo XML
nmap -p- -sV -sC -oX scan_result.xml $ip

# Analisa o resultado do scan para identificar possíveis vulnerabilidades em cada host
for host in $(grep -oP '<host (?!endtime)' scan_result.xml); do
    hostname=$(echo $host | grep -oP '(?<=<hostname>).*(?=</hostname>)')
    ip=$(echo $host | grep -oP '(?<=<address addr=").*(?=")')
    echo "===================="
    echo "Host: $hostname ($ip)"
    echo "===================="
    nmap -sV --script vuln $ip
done
