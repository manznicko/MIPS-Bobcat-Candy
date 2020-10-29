.data 
str0: .asciiz "Welcome to BobCat Candy, home to the famous BobCat Bars!\n"
# Declare any necessary data here
str1: .asciiz "Please enter the price of a BobCat Bar: \n"
str2: .asciiz "Please enter the number of wrappers needed to exchange for a new bar: \n"
str3: .asciiz "How, how much do you have?\n"
str4: .asciiz "Good! Let me run the numbers ...\n"
str5: .asciiz "You first buy "
bars: .asciiz " bars. \n"
str6: .asciiz "Then, you will get another "
str7: .asciiz "With $"
str7.1: .asciiz ", you will receive a maximum of "
str7.2: .asciiz " BobCat Bars!"
checkp: .asciiz "Price cannot be 0 or negative.\n"
checkw: .asciiz "Wrappers traded in cannot be negative.\n"
checkm: .asciiz "Money you have cannot be negative. \n"
wrap1: .asciiz "indefinite"
.text

main:
		#This is the main program.
		#It first asks user to enter the price of each BobCat Bar.
		#It then asks user to enter the number of bar wrappers needed to exchange for a new bar.
		#It then asks user to enter how much money he/she has.
		#It then calls maxBars function to perform calculation of the maximum BobCat Bars the user will receive based on the information entered. 
		#It then prints out a statement about the maximum BobCat Bars the user will receive.
		
		addi $sp, $sp -4	# Feel free to change the increment if you need for space.
		sw $ra, 0($sp)
		# Implement your main here
		li $v0, 4
		la $a0, str0
		syscall
		
		li $v0, 4
		la $a0, str1
		syscall
		li $v0, 5
		syscall 
		move $a1, $v0 #price
Price:		bgt $a1, $zero, Wrapper
		li, $v0, 4
		la $a0, checkp
		syscall
		li $v0, 4
		la $a0, str1
		syscall
		li $v0, 5
		syscall
		move $a1, $v0
		j Price
		
Wrapper:		
		li $v0, 4
		la $a0, str2
		syscall
		li $v0, 5
		syscall 
		move $a2, $v0 #n wrappers
		bge $a2, $zero, Money
		li, $v0, 4
		la $a0, checkw
		syscall
		j Wrapper		
		
Money:		li $v0, 4
		la $a0, str3
		syscall
		li $v0, 5
		syscall 
		move $a3, $v0 #Moneys
		bge $a3, $zero After
		li, $v0, 4
		la $a0, checkm
		syscall
		j Money
After:		
		li $v0, 4
		la $a0, str4
		syscall
		add $s0, $zero, $zero
		add $s1, $zero, $zero
		add $s2, $zero, $zero 
		add $s3, $zero, $a3 
		
		jal maxBars 	# Call maxBars to calculate the maximum number of BobCat Bars

		# Print out final statement here



		j end			# Jump to end of program



maxBars:
		# This function calculates the maximum number of BobCat Bars.
		# It takes in 3 arguments ($a0, $a1, $a2) as n, price, and money. It returns the maximum number of bars
		blt $s3, $a1 Next
		sub $s3, $s3, $a1
		addi $s1, $s1, 1	#Use s1 as inital bars total
		
		j maxBars 
		
		
Next:		blt $a3, $a1, end
		add $s0, $zero, $s1	#Use s0 as total
		li $v0, 4
		la $a0, str5
		syscall
		move $a0, $s1
		li $v0, 1
		syscall
		la $a0, bars
		li $v0, 4
		syscall
		beq $a2, $zero, end
		addi $t0, $zero, 1
		beq $a2, $t0, end
		jal newBars 	# Call a helper function to keep track of the number of bars.
		

		
		jr $ra
		# End of maxBars

newBars:
		# This function calculates the number of BobCat Bars a user will receive based on n.
		# It takes in 2 arguments ($a0, $a1) as number of wrappers left so far and n.
		
		blt $s1, $a2, Continue
		sub $s1, $s1, $a2 
		addi $s2, $s2, 1
		
		j newBars
		
Continue:	beq $s2, $zero, end
		add $s0, $s0, $s2
		add $s1, $s1, $s2
		li $v0, 4
		la $a0, str6
		syscall
		move $a0, $s2
		li $v0, 1
		syscall
		la $a0, bars
		li $v0, 4
		syscall
		add $s2, $zero, $zero
		
		j newBars	
		
		jr $ra
		# End of newBars

end: 		
		li $v0, 4
		la $a0, str7
		syscall
		move $a0, $a3
		li $v0, 1
		syscall
		li $v0, 4
		la $a0, str7.1
		syscall
		
		addi $t0, $zero, 1
		beq $a3, $zero, num
		beq $a2, $t0, one		
num:		li $v0 1
		move $a0, $s0
		syscall
		j final
one:		li $v0, 4
		la $a0, wrap1
		syscall
		
final:		li $v0, 4
		la $a0, str7.2
		syscall
		
		# Terminating the program
		lw $ra, 0($sp)
		addi $sp, $sp 4
		li $v0, 10 
		syscall
