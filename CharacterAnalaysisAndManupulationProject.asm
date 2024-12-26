# Title:	Filename:
# Author:	Date:
# Description:
# Input:
# Output:
################# Data segment #####################
.data
                     ### add your data here ###
                     ResultArray:      .space 26
                     CharStr:            .asciiz "AEZKLBXWZXYALKFKWZRYLAKWLQLEK"
                     
                     message:      .asciiz "The char with the most occurrences in the string is:"
                     message2 :   .asciiz ", Number of occurences is:"
                     message3 :   .asciiz " \nDo you want to perform mission 1-4 again for the small string? enter 0 for no and 1 for yes :"
                     lineDown :    .asciiz "\n"
                     
                     
                     
                     
################# Code segment #####################
.text
.globl main
main:	# main program entry
                ### add your code here  ####
                    
                  MissionsOneToFour:
                     	la $a0, CharStr
                    	la $a1, ResultArray
                    	jal char_occurrences
                     
                    	move $a1, $v0
                     	move $s5, $v0         		# Saving $v0 value for delete procedure going forward
                    	move $a2, $v1          
                     
                     	li $v0, 4
                     	la $a0, message    		# Printing  message:  "the char with the most occurrences in the string"
                     	syscall
                     
                    	li $v0, 11
                    	move $a0, $a1        
                     	syscall                     		# Printing  the relevant char"
                     
                     
                     	li $v0, 4
                    	la $a0, message2  		#printing message: " Number of occurences is"
                     	syscall
                     
                      	li $v0, 1
                     	move $a0, $a2
                    	syscall                    			# Printing  the relevant number of occurences
                    
                    	li $v0, 4
                    	la $a0, lineDown  			# A linebreak
                    	syscall
                     
                     	la, $a1, ResultArray
                     	jal print_Char_by_occurrences
                     
                     
                    	la $a0, CharStr
                    	move $a1, $s5                     
                   	 jal delete
                    
                    
                    
                    
                    la $a0, message3
                    li $v0, 4
                    syscall                       				# Printing  message:  "Do you want to perform mission 1-4 again for the small string? enter 0 for no and 1 for yes"
                    li $v0, 5
                    syscall
                    
                    
                    
                    
                   la $a0, CharStr
                   lbu $a1, CharStr($0)
                   beq $a1, $0, exit          			# If the String is empty (After the user deleted the popular letter at least one time, the program is over)
                   
                   
                   
                   
                    
                    beq $v0, 1,  restartResultArray     # If the user wants to repreat levels 1-4 again, the program should delete all values of ResultArray, otherwise the values will surpass each other
                    beq $v0, 0, exit
                    
                    restartResultArray:
                    	li $t1, 0  						# index in ResultArray
                    	
                    	restartLoop:
                    		sb, $0, ResultArray($t1)
                    		addi $t1, $t1, 1
                    		beq $t1, 26, MissionsOneToFour   # After all values were deleted, the program repeat levels 1-4 again
                    		j restartLoop
                     
                     
                     

                      
        	


### remember: program always has to finish here ###
exit:
	li $v0, 10	# Exit program
	syscall



char_occurrences:
	

	##### char_occurrences: update reulstArray in counted values of ABC.. in the string ####
	
	move $t0, $a0
	move $t1, $a1                                                           	# $t1 = address of result array
	li $t2, 0                                                                           # $t2 holds the index for passing over the array
	li $t3, 0x41                                                                   	# $t3 holds the ascii code of the letters in ABC.. starting from A (for counting)
	li $t5, 0x5A 									# $t5 = ascii code of Z (last letter to check)
	#li $t7, 1                                                                 		# $t7 holds the char from memory
	                                                                                   
	
	
	scanArray:	
		lb $t7, 0($t0)                                                         	# get the char from memory
		beq $t7, $zero, nextLetter                                      	# if $t2 = the array length, the loop was finished running all over the array                                  
		beq $t7, $t3, addOneInResultArray                 	# if the char equalls to current checked letter, add one in ResultArray
		addi $t0, $t0, 1
		j scanArray
		
		addOneInResultArray:
			lbu $t9, 0($t1)                                         	# get the current occurences of the char
			addi $t9, $t9, 1                             			# add one
			sb $t9, 0($t1)                        				# update ResultArray
			addi $t0, $t0, 1						# promoting index by on
			j scanArray
			
		nextLetter:
			beq $t3, $t5, getTheCharWithTheMostOccurences		       		#if $t3 == $t5, we finished to scan the array, becase $t3 started by A and "bacame" Z
			move $t0, $a0												# intiliaztion of $t2 to 0
			addi, $t3, $t3, 1												# next letter in ABC..  to count
			addi $t1, $t1, 1												# next index in target array
			j scanArray
			
	
	#### char_occurrences: Finding the char with the most occurences and update $v0 and $v1 registers ####
						
	getTheCharWithTheMostOccurences:
		move $t0, $a0
		move $t1, $a1
		li $t2, 0					 		    		# index for getting the letter with maximum occurences result array
		
		li $t6, 65                                                     		# represents max letter
		li $t8, 65                                                     		# represents return letter
		lbu $t5, 0($t1)					    		
		addi $t1, $t1, 1
		addi $t2, $t2, 1
						
		scanRest:
			lbu $t4, 0($t1)				   		# $t4 = char value
			beq $t2, 26, returnMax 			       	# means: the scan is over
			beq $t4, $t5, newMax			   		# if $t4 is equalls or bigger than the maximum char, $t4 is the new man
			bgt $t4, $t5, newMax
			addi $t1, $t1, 1
			addi $t2, $t2, 1
			j scanRest
				
		newMax:
			move $t5, $t4                                   		# $t4 is the new max
			add $t8, $t6, $t2				   		# $t8 getting the letter ascii value for the max
			addi $t1, $t1, 1
			addi $t2, $t2, 1
			j scanRest
				
		returnMax:
			move $v0, $t8
			move $v1, $t5
			jr $ra
				
			
			
			
		
print_Char_by_occurrences:
	move $t1, $a1               								# address of ResultArray
	li $t2, 65             								# ascii code of letters, starting from A
	li $t5, 90										# ascii code of last Letter, Z
	li $t6, 0              								# "boolean register" - if a letter had any occurences $t6 = 1 ,   else:   $t6 = 0								
	
	 Loop:
	 	lbu $t4, 0($t1)     							# $t4 = ResultArray[i]
	 	print: 
	 			
	 		beq $t4, $zero, moveToNextLetter
	 		li $t6, 1								# if the currnet chcked char has occurences, $t6 = 1, to know thar an enter will be required
	 		li $v0, 11
	 		move $a0, $t2
	 		syscall
	 		addi $t4, $t4, -1
	 		j print
	 		
	 	moveToNextLetter:
	 		beq $t2, 90, finish	   					#If we came to 'z' we are done	 		
	 		addi $t1, $t1, 1            					#next index
	 		addi $t2, $t2, 1          					#next letter in ascii
	 		lbu $t4, 0($t1)          					# getting the value
	 		beq $t6, 1, printEnter 					# if the letter before has any occurences, print enter
	 		li $t6, 0	 
	 		j print	
	 			 		 		 		 	
	 		
	 	printEnter:
	 		li $v0, 4
	 		la $a0, lineDown
	 		syscall
	 		li $t6, 0
	 		j print
	 	
	 	finish:
	 		jr $ra
	 	
	


delete:        
	addi $sp, $sp, -4  
	sw $ra, 4($sp)           							#in delete procedure we call another procedure(reduction), so we have to save $ra value in stock.

	move $t0, $a0   								# $t0 - address of string
	move $t1, $a1     								# $t1 - ascii code
	
	searchTheLetter:
		lbu $t4, 0($t0)          						# $t4 - value
		beq $t4, $0, deleteDone  					# if $t4 = 0, the procedure passed all over the letters in the string, so delete is done
		beq $t4, $t1, letterFound
		addi $t0, $t0, 1
		j searchTheLetter
		
	letterFound:
		move $a0, $t0
		jal reduction
		addi $t0, $t0, 1
		j searchTheLetter
		
	deleteDone:
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	jr $ra

	
		
reduction:
	addi $sp, $sp, -12
	sw, $s0, 4($sp)
	sw, $s1, 8($sp)
	sw, $s2, 12($sp)



	move $s0, $a0       						
	addi $s1, $s0, 1       				
	
	reductionLoop:
		lbu $s2, 0($s1)            						
		beq $s2, $0, putNull 						
		sb $s2, 0($s0)             						
		addi $s0, $s0, 1           						
		addi $s1, $s1, 1	   					
		j reductionLoop
		
	putNull:
	sb, $0, 0($s0)
	lw, $s2, 12($sp)
	lw, $s1, 8($sp)
	lw, $s0, 4($sp)
	addi $sp, $sp, 12
	
	
	jr $ra
	
	
