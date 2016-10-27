[BITS 32]

[GLOBAL liballoc_lock]
[GLOBAL liballoc_unlock]
[GLOBAL liballoc_alloc]
[GLOBAL liballoc_free]

;This function is supposed to lock the memory data structures. It
;could be as simple as disabling interrupts or acquiring a spinlock.
;It's up to you to decide.
;return 0 if the lock was acquired successfully. Anything else is
;failure.
liballoc_lock:
	;TODO Lock up so nothing happens
	mov eax, 0x0	;return value
	ret

;This function unlocks what was previously locked by the liballoc_lock
;function.  If it disabled interrupts, it enables interrupts. If it
;had acquiried a spinlock, it releases the spinlock. etc.
;return 0 if the lock was successfully released.
liballoc_unlock:
	;TODO UnLock so something happens
	mov eax, 0x0	;return value
	ret

;This is the hook into the local system which allocates pages. It
;accepts an integer parameter which is the number of pages
;required.  The page size was set up in the liballoc_init function.
;return NULL if the pages were not allocated.
;return A pointer to the allocated memory.
liballoc_alloc:
	pop eax			;get the number of pages of the stack
	mov eax, 0x0	;TODO actually return pointer
	ret

liballoc_free:
	pop eax		;get the pointer to the start of the memory
	pop ebx		;number of pages to free...
	mov eax, 0x0 ;return value
	ret
