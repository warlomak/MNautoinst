# MNautoinst
video: https://www.youtube.com/watch?v=4dBWG7lMlvk

1. Create text file to save settings of your masternode.
2. Start wallet and wait for full sync.
3. Create new address for masternode.
4. Enable coin control (Help - Debug Window - Console).
5. check you have 2000 coins on single input
6. Send 2000 coins to MN address.
7. Copy id of this transaction.
8. Generate masternode private key, get transaction output index and copy them in text file.
  Console commands:
   'masternode genkey'
   'masternode outputs'
9. connect to your vps server. 

# mkdir ./jg
# cd ./jg

10. download the install scrypt jg_install_daemon.
    # wget https://raw.githubusercontent.com/warlomak/MNautoinst/master/jg_install_daemon

11. change permissions of scrypt and run ./jg_install_daemon (MASTERNODE PRIVATE KEY FROM STEP 8)
---wait for scrypt finished install MN daemon.
12. check NM work check_mn_status.sh.
13. Create new masternode on 'masternode' tab. Use the tx id and output index from steps "7,8"
14. Start masternode.
15. Check that your masternode work.
Console commands:
 'masternode status'
 'masternode debug'

JLG donation address: JNWLVdZauWJp1z8timBU3cnihYvbMLwZjq
