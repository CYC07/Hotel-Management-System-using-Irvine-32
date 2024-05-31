INCLUDE Irvine32.inc

.DATA
    Room STRUCT
        roomNumber DWORD ?
        roomSize DWORD ?
        roomPrice REAL8 ?
        isAC BYTE ?
        isBooked BYTE ?
        isDouble BYTE ?
        hasRoomService BYTE ?
        isCheckedOut BYTE ?
        dateOfBooking BYTE 20 DUP(?)
        isReserved BYTE ?
    Room ENDS

    roomArray Room 100 DUP(<>)
    numRooms DWORD 0

    roomNumberInput DWORD ?
    roomIndexFound DWORD ?
    promptMsg BYTE "Enter room number: ", 0
    promptMsg1 BYTE "Enter room size: ", 0
    roomNotFoundMsg BYTE "Room not found!", 0
    bookingSuccessMsg BYTE "Room booked successfully!", 0
    reservationSuccessMsg BYTE "Room reserved successfully!", 0
    reservationCancelMsg BYTE "Reservation canceled successfully!", 0
    invalidRoomSizeMsg BYTE "Invalid size entered",0
    roomDeleteMsg BYTE "Room deleted successfully!", 0
    roomModifyMsg BYTE "Room modified successfully!", 0
    checkoutSuccessMsg BYTE "Room checked out successfully!", 0
    roomAddSuccessMsg BYTE "Room Added Successfully", 0
    cancelSuccessMsg BYTE "Reservation canceled successfully!", 0
    roomNumberExistsMsg BYTE "Room Number is already allotted", 0
    bookedRoomsHeader BYTE "Booked Rooms:", 0
    reservedRoomsHeader BYTE "Reserved Rooms:", 0
    checkoutRoomPrompt BYTE "Enter room number to check out: ", 0
    cancelReservationPrompt BYTE "Enter room number to cancel reservation: ", 0
    menuHeader BYTE "Hotel Management System Menu", 0
    menuOption1 BYTE "1. Add Room", 0
    menuOption2 BYTE "2. Reserve Room", 0
    menuOption3 BYTE "3. Book Room", 0
    menuOption4 BYTE "4. Modify Room", 0
    menuOption5 BYTE "5. Delete Room", 0
    menuOption6 BYTE "6. Check Booked Rooms", 0
    menuOption7 BYTE "7. Check Reserved Rooms", 0
    menuOption8 BYTE "8. Cancel Reservation", 0
    menuOption9 BYTE "9. Checkout Room", 0
    menuOption10 BYTE "10. Exit", 0
    comma byte ",",0

    promptMenuOption BYTE "Enter menu option: ", 0
    invalidOptionMsg BYTE "Invalid option. Please try again.", 0

.CODE
main PROC
    mov ebx, 0 ; Initialize menu option variable

mainLoop:
    call displayMenu
    call MenuInput
    cmp eax, 1
    je addRoomOption
    cmp eax, 2
    je reserveRoomOption
    cmp eax, 3
    je bookRoomOption
    cmp eax, 4
    je modifyRoomOption
    cmp eax, 5
    je deleteRoomOption
    cmp eax, 6
    je checkBookedRoomsOption
    cmp eax, 7
    je checkReservedRoomsOption
    cmp eax, 8
    je cancelReservationOption
    cmp eax, 9
    je checkoutRoomOption
    cmp eax, 10
    je exitProgram


    mov edx, OFFSET invalidOptionMsg
    call WriteString
    call Crlf
    jmp mainLoop

addRoomOption:
    call addRoom
    jmp mainLoop

reserveRoomOption:
    call reserveRoom
    jmp mainLoop

bookRoomOption:
    call bookRoom
    jmp mainLoop

modifyRoomOption:
    call modifyRoom
    jmp mainLoop

deleteRoomOption:
    call deleteRoom
    jmp mainLoop

checkBookedRoomsOption:
    call checkBookedRooms
    jmp mainLoop

checkReservedRoomsOption:
    call checkReservations
    jmp mainLoop

cancelReservationOption:
    call cancelReservation
    jmp mainLoop

checkoutRoomOption:
    call checkoutRoom
    jmp mainLoop

exitProgram:
    invoke ExitProcess, 0

main ENDP

                                        ;searchRoom PROC                ;RAO ZAIN 
;---------------------------------------------------------------------------------------------------------------------------

searchRoom PROC
    mov esi, 0
    mov roomIndexFound, -1

searchLoop:
    cmp esi, numRooms
    je roomNotFoundSearch

    mov eax, roomNumberInput
    mov ebx, SIZEOF Room
    imul ebx, esi
    mov ecx, roomArray[ebx].Room.roomNumber
    cmp eax, ecx
    je roomFoundSearch
 
    inc esi
    jmp searchLoop

roomFoundSearch:
    mov roomIndexFound, esi
    ret

roomNotFoundSearch:
    call waitMsg
     call clrScr
    ret
searchRoom ENDP


                                                   ; deleteRoom PROC                     ;RAO ZAIN 
;---------------------------------------------------------------------------------------------------------------------------

deleteRoom PROC
    call promptRoomNumber
    call searchRoom

    cmp roomIndexFound, -1
    je roomNotFoundDelete

    mov esi, roomIndexFound
    mov ecx, numRooms
    dec ecx

deleteLoop:
    cmp esi, ecx
    je endDelete

    mov edi, esi
    inc edi
    mov eax, SIZEOF Room
    imul eax, edi
    lea esi, roomArray[eax]
    imul eax, SIZEOF Room
    sub esi, eax
    mov ecx, SIZEOF Room
    rep movsb

    inc esi
    jmp deleteLoop

endDelete:
    dec numRooms

    mov edx, OFFSET roomDeleteMsg
    call WriteString
    jmp deleteDone

roomNotFoundDelete:
    mov edx, OFFSET roomNotFoundMsg
    call WriteString

deleteDone:
   call waitMsg
     call clrScr
   ret
   
deleteRoom ENDP
                                                                      
                                                        ;modifyRoom PROC                     ;RAO ZAIN 

;---------------------------------------------------------------------------------------------------------------------------


modifyRoom PROC
    call promptRoomNumber
    call searchRoom

    cmp roomIndexFound, -1
    je roomNotFoundModify

    mov esi, roomIndexFound
    mov eax, SIZEOF Room
    imul eax, esi
    add eax, OFFSET roomArray

    
    mov edx, OFFSET promptMsg1
    call WriteString
    call ReadInt
    mov ebx, eax                         ; Store room size in ebx for checking

   
    cmp ebx, 1     ; Minimum room size
    jl invalidRoomSize
    cmp ebx, 100   ; Maximum room size
    jg invalidRoomSize

   
    mov [eax].Room.roomSize, ebx         ; If room size is within the valid range, update it in the room structure

    ; Display success message
    mov edx, OFFSET roomModifyMsg
    call WriteString

    jmp modifyDone

invalidRoomSize:
    mov edx, OFFSET invalidRoomSizeMsg
    call WriteString
    jmp modifyDone

roomNotFoundModify:
    mov edx, OFFSET roomNotFoundMsg
    call WriteString

modifyDone:
    
    call waitMsg
    
    call clrScr
    ret
modifyRoom ENDP


                                                     ;bookRoom PROC                      ;RAO ZAIN 
;---------------------------------------------------------------------------------------------------------------------------


bookRoom PROC
    call promptRoomNumber
    call searchRoom

    cmp roomIndexFound, -1
    je bookingFailed

    mov esi, roomIndexFound
    mov eax, SIZEOF Room
    imul eax, esi
    add eax, OFFSET roomArray

    mov [eax].Room.isBooked, 1
    mov edx, OFFSET bookingSuccessMsg
    call WriteString

    jmp bookingDone

bookingFailed:
    mov edx, OFFSET roomNotFoundMsg
    call WriteString

bookingDone:
    
    call waitMsg
    call clrScr
    ret
bookRoom ENDP

                                                    ;reserveRoom PROC                ;RAO ZAIN 
;---------------------------------------------------------------------------------------------------------------------------

reserveRoom PROC
    call promptRoomNumber
    call searchRoom

    cmp roomIndexFound, -1
    je reservationFailed

    mov esi, roomIndexFound
    mov eax, SIZEOF Room
    imul eax, esi
    add eax, OFFSET roomArray

    mov [eax].Room.isReserved, 1
    mov edx, OFFSET reservationSuccessMsg
    call WriteString

    jmp reservationDone

reservationFailed:
    mov edx, OFFSET roomNotFoundMsg
    call WriteString

reservationDone:
    
    call waitMsg
     call clrScr
    ret
reserveRoom ENDP


                                                    ;addRoom PROC
;---------------------------------------------------------------------------------------------------------------------------


addRoom PROC
    mov esi, numRooms              
    cmp esi, 100                   
    je maxRoomsReached             

    mov eax, SIZEOF Room          
    imul eax, esi                  
    add eax, OFFSET roomArray      
    mov edi, eax                   

    ; Prompt user for new room number
    mov edx, OFFSET promptMsg
    call WriteString
    call ReadInt                   
    mov [edi].Room.roomNumber, eax 

    ; Prompt user for new room size
    mov edx, OFFSET promptMsg1
    call WriteString
    call ReadInt                   
    mov [edi].Room.roomSize, eax   

    
    inc numRooms                  
    mov edx, OFFSET roomAddSuccessMsg
    call WriteString
    
    jmp addRoomDone

maxRoomsReached:
       ret

addRoomDone:
    call crlf
    call waitMsg
     call clrScr
     ret
addRoom ENDP





                                                    ;checkReservations PROC
;---------------------------------------------------------------------------------------------------------------------

checkReservations PROC
    mov edx, OFFSET reservedRoomsHeader
    call WriteString
    mov esi, 0

checkReservationsLoop:
    cmp esi, numRooms
    je checkReservationsDone

    mov eax, SIZEOF Room
    imul eax, esi
    add eax, OFFSET roomArray
    cmp [eax].Room.isReserved, 1
    jne nextReservation

    ; Display room details
    mov eax, [eax].Room.roomNumber
    call WriteDec
    call Crlf

nextReservation:
    inc esi
    jmp checkReservationsLoop

checkReservationsDone:
   
    call waitMsg
     call clrScr
     ret
checkReservations ENDP

                                                      ; checkBookedRooms PROC
;---------------------------------------------------------------------------------------------------------------------------


checkBookedRooms PROC
    mov edx, OFFSET bookedRoomsHeader
    call WriteString
    mov esi, 0

checkBookedRoomsLoop:
    cmp esi, numRooms
    je checkBookedRoomsDone

    mov eax, SIZEOF Room
    imul eax, esi
    add eax, OFFSET roomArray
    cmp [eax].Room.isBooked, 1
    jne nextBookedRoom

    ; Display room details
    mov eax, [eax].Room.roomNumber
    call WriteDec
    call Crlf
    
    
    

nextBookedRoom:
    inc esi
    jmp checkBookedRoomsLoop

checkBookedRoomsDone:
    call waitMsg
     call clrScr
    ret
checkBookedRooms ENDP



                                                       ;cancelReservation PROC
;---------------------------------------------------------------------------------------------------------------------------

cancelReservation PROC
    call promptRoomNumber
    call searchRoom

    cmp roomIndexFound, -1
    je cancelFailed

    mov esi, roomIndexFound
    mov eax, SIZEOF Room
    imul eax, esi
    add eax, OFFSET roomArray
    mov [eax].Room.isReserved, 0

    mov edx, OFFSET cancelSuccessMsg
    call WriteString
    jmp cancelDone

cancelFailed:
    mov edx, OFFSET roomNotFoundMsg
    call WriteString
    
    call waitMsg
     call clrScr

cancelDone:
    call waitMsg
     call clrScr
    ret
cancelReservation ENDP

                                                    ;checkoutRoom PROC
;---------------------------------------------------------------------------------------------------------------------------

checkoutRoom PROC
    call promptRoomNumber
    call searchRoom

    cmp roomIndexFound, -1
    je checkoutFailed

    mov esi, roomIndexFound
    mov eax, SIZEOF Room
    imul eax, esi
    add eax, OFFSET roomArray
    mov [eax].Room.isCheckedOut, 1

    mov edx, OFFSET checkoutSuccessMsg
    call WriteString
    jmp checkoutDone

checkoutFailed:
    mov edx, OFFSET roomNotFoundMsg
    call WriteString
   
    call waitMsg
     call clrScr

checkoutDone:
    call waitMsg
     call clrScr
    ret
checkoutRoom ENDP

                                                           ;displayMenu PROC
;---------------------------------------------------------------------------------------------------------------------------

displayMenu PROC
    
    mov edx, OFFSET menuHeader
    call WriteString
    call Crlf
    mov edx, OFFSET menuOption1
    call WriteString
    call Crlf
    mov edx, OFFSET menuOption2
    call WriteString
    call Crlf
    mov edx, OFFSET menuOption3
    call WriteString
    call Crlf
    mov edx, OFFSET menuOption4
    call WriteString
    call Crlf
    mov edx, OFFSET menuOption5
    call WriteString
    call Crlf
    mov edx, OFFSET menuOption6
    call WriteString
    call Crlf
    mov edx, OFFSET menuOption7
    call WriteString
    call Crlf
    mov edx, OFFSET menuOption8
    call WriteString
    call Crlf
    mov edx, OFFSET menuOption9
    call WriteString
    call Crlf
    mov edx, OFFSET menuOption10
    call WriteString
    call Crlf

    ret
displayMenu ENDP

                                                        ;MenuInput PROC
;---------------------------------------------------------------------------------------------------------------------------

MenuInput PROC
    mov edx, OFFSET promptMenuOption
    call WriteString
    call ReadInt
    mov eax, eax ; Return the input value in eax
    ret
MenuInput ENDP


                                                    ;promptRoomNumber PROC
;---------------------------------------------------------------------------------------------------------------------------

promptRoomNumber PROC
    mov edx, OFFSET promptMsg
    call WriteString
    call ReadInt
    mov roomNumberInput, eax ; Store the input room number in roomNumberInput
    ret
promptRoomNumber ENDP

;---------------------------------------------------------------------------------------------------------------------------

END main



