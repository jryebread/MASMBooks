
INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.data

msg BYTE "How many books? <20 max> ", 0dh, 0ah, 0
msgError BYTE "Please enter less than 20", 0dh, 0ah, 0
Titles BYTE "BookID	Points	Sales Label", 0dh, 0ah,0
Label1 BYTE "Best Seller", 0dh, 0ah, 0
Label2 BYTE "Good Seller", 0dh, 0ah, 0
Label3 BYTE "Average Seller", 0dh, 0ah, 0
Label4 BYTE "Poor seller - Flagged for discount", 0dh, 0ah, 0
newSpace BYTE "       ", 0dh, 0ah, 0
randNumArray DWORD 20 DUP (?)
bookID DWORD 20 DUP (?)
tabr BYTE 9h, 0

.code  		;// write your program here
main PROC
call Randomize

call AskHowMany
mov ebx, eax;// ebx now holds the number of loops of ecx
call crlf
mov edx, OFFSET Titles
call WriteString
call crlf
mov ecx, ebx;// ECX is the counter for loop operations, so we put our input, or the length of the array into it
mov edi, OFFSET bookID;// move the OFFSET of the first element of the array into edi
call FillArrayID

mov esi, OFFSET randNumArray;// move the OFFSET of the first element of the array into esi
mov edi, OFFSET bookID;// move the OFFSET of the first element of the array into edi
mov ecx, ebx;// ECX is the counter for loop operations, so we put our input, or the length of the array into it
call FillRandomArray;// Fills Random array


mov esi, OFFSET randNumArray;// move the OFFSET of the first element of the array into esi
mov edi, OFFSET bookID;// move the OFFSET of the first element of the array into edi
mov ecx, ebx;// ECX is the counter for loop operations

L3:;//print
call PrintID
mov edx, OFFSET tabr
call WriteString
call PrintRandom
mov edx, OFFSET tabr
call WriteString
call CalculateRanking
loop L3




invoke ExitProcess, 0
main endp
;//________CUSTOM_PROCEDURES____________//

;//____CALCULATE_RANKING____
;//USES EAX REGISTER TO GET NUMBER OF POINTS. RECIEVES: EAX
;//AND OUTPUTS A STRING
CalculateRanking proc
push edx
cmp eax, 39;// is eax <= 39?
jnle next1;// if eax !<= 39 then jump ahead
mov edx, OFFSET Label4;// else print out label and end CR
call WriteString
jmp endofcr

next1:
cmp eax, 59
jnle next2
mov edx, OFFSET Label3
call WriteString
jmp endofcr

next2:
cmp eax, 79
jnle next3
mov edx, OFFSET Label2
call WriteString
jmp endofcr

next3:
mov edx, OFFSET Label1
call WriteString
endofcr:
pop edx
ret
CalculateRanking endp

;//FILLS THE INCREMENTED ID's TAKES IN EDI AND ECX AND RETURNS THEM
FillArrayID PROC
push edi
push ecx
mov eax, 0
	L1:
inc eax
mov[edi], eax
add edi, TYPE DWORD
loop L1
pop ecx
pop edi
ret
FillArrayID ENDP

;// PRINTS THE ID ARRAY ONE ITEM
PrintID PROC
mov eax, [edi];// mov the current book Id into eax for print
cmp edi, 0
call WriteInt;//print
add edi, TYPE bookID;//increment
ret
PrintID ENDP

;//FILLS A RANDOM ARRAY 
FillRandomArray PROC

L1:
	mov eax, 100
	call RandomRange
	inc eax
	mov [esi], eax
	add esi, TYPE DWORD
		loop L1
	ret
FillRandomArray ENDP

;//__PROC PRINTS A ONE POINT TO CONSOLE
PrintRandom proc
mov eax, [esi];// will use later for calculateRanking
call WriteInt
add esi, TYPE DWORD;//increment
ret
PrintRandom endp


;//____PROC JUST ASKS FOR HOW MANY BOOKS AND ERROR CHECKS___
AskHowMany proc
HowMany :
	mov edx, offset msg
	call WriteString; // writes the message to the console
	call ReadInt
		cmp eax, 20
		jg Error
		jle Table
Error :
	mov edx, offset msgError
	call WriteString; // writes the message to the console
	jmp HowMany
Table :
ret
AskHowMany endp


end main
