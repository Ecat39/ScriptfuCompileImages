(define (script-fu-compile inDir inFile inType inNumber inX inY inWidth inHeight)
  (let*
        (
		   (requiredSets (+ (quotient (car (gimp-image-list)) inNumber) (if (= (remainder (car (gimp-image-list)) inNumber) 0) 0 1)))
		   (requiredImage 0)
		   (localNumber 0)
		   (newLayer)
		   (setNumber 1)
           (combinedImageHeight (* inHeight inNumber))
		   (theImage)
		   (theLayer)
		   (sourceImage 1)
		   (selectedArea 0)
		   (limitNumber inNumber)
		   (newX 0)
		   (newY 0)
		   (newFileName "")
		   (saveType "")
		   (pathchar (if (equal? 
                 (substring gimp-dir 0 1) "/") "/" "\\"))
        ) ; define our local variables
	(if (= (remainder inNumber 2) 0) 
		(set! newY (+ (/ inHeight 2) (* -1 (quotient inNumber 2) inHeight)))
		(set! newY (* -1 (quotient inNumber 2) inHeight))
	) ;check if number of opened images is a multiple of Number of Images, else create new images to make it a multiple
	(if (= (remainder (car (gimp-image-list)) inNumber) 0) 
		(set! requiredImage 0)
		(set! requiredImage (- (* requiredSets inNumber) (car (gimp-image-list))))
	) ;configure translation offset based on whether inNumber is odd or even
	(set! saveType
      (cond 
        (( equal? inType 0 ) ".png" )
        (( equal? inType 1 ) ".jpg" )
      )
    ) ;configure type of file image is to be saved in
	(while (< localNumber requiredImage)
		(set! theImage (car (gimp-image-new inWidth inHeight RGB))) 
		(set! theLayer (car (gimp-layer-new theImage inWidth inHeight RGB-IMAGE "layer 1" 0 LAYER-MODE-NORMAL))) 
		(gimp-layer-add-alpha theLayer)
		(gimp-image-insert-layer theImage theLayer 0 0)
			(set! localNumber (+ localNumber 1))
	)
	(while (<= setNumber requiredSets)
	(set! theImage (car (gimp-image-new inWidth combinedImageHeight RGB))) 
		(gimp-message-set-handler 2)(gimp-message "Step 1 Completed" )
    (set! theLayer (car (gimp-layer-new theImage inWidth combinedImageHeight RGB-IMAGE "layer 1" 0 LAYER-MODE-NORMAL))) 
		(gimp-message-set-handler 2)(gimp-message "Step 2a Completed" )
	(gimp-layer-add-alpha theLayer) (gimp-message-set-handler 2)(gimp-message "Step 2b Completed" )
    (gimp-image-insert-layer theImage theLayer 0 0)
		(gimp-message-set-handler 2)(gimp-message "Step 3 Completed")
			(while (<= sourceImage limitNumber)
					(gimp-image-select-rectangle sourceImage 0 inX inY inWidth inHeight) (gimp-message-set-handler 2)(gimp-message "Step 4a Completed" )
					(set! selectedArea (car(gimp-image-get-active-drawable sourceImage))) (gimp-message-set-handler 2)(gimp-message "Step 4b Completed" )
					(gimp-edit-copy selectedArea) (gimp-message-set-handler 2)(gimp-message "Step 4c Completed" )
					(gimp-selection-none sourceImage) (gimp-message "Step 4d Completed" )
					(gimp-floating-sel-anchor (car 
						(gimp-item-transform-translate (car
							(gimp-edit-paste 
									(car (gimp-image-get-active-drawable theImage)) TRUE
							)) 0 newY
						))
					) (gimp-message-set-handler 2)(gimp-message "Step 4e Completed" )
						(set! sourceImage (+ sourceImage 1))
						(set! newY (+ newY inHeight))
			) (gimp-message-set-handler 2) (gimp-message (string-append "Step 4 Completed " (number->string (- sourceImage 1)) " times"))
	(set! newFileName (string-append inDir pathchar inFile " " (number->string setNumber) saveType)
	) (gimp-message-set-handler 2)(gimp-message "Step 5 Completed" )
    (gimp-file-save RUN-NONINTERACTIVE 
                      theImage
                      (car (gimp-image-get-active-layer theImage))
                      newFileName
                      newFileName
    ) (gimp-message-set-handler 2)(gimp-message (string-append "File: " inFile " " (number->string setNumber) saveType " Saved"))
	(gimp-image-delete theImage)
	(set! setNumber (+ setNumber 1))
	(set! limitNumber (+ limitNumber inNumber))
	(if (= (remainder inNumber 2) 0) 
		(set! newY (+ (/ inHeight 2) (* -1 (quotient inNumber 2) inHeight)))
		(set! newY (* -1 (quotient inNumber 2) inHeight))
	) ;reset back translation offset to initial value
	)
	)
)
 
(script-fu-register "script-fu-compile" 
 "<Image>/Compile" 
 "Copy a selected area in all opened images and compile them in sets that the user defines in 1 image" 
 "Ecat39" 
 "Ecat39" 
 "2023/08/10" 
 ""
 SF-DIRNAME    "Save Directory" ""
 SF-STRING     "Save File Base Name" "Compiled"
 SF-OPTION     "Save File Type" 
  (list "png" "jpg")
 SF-ADJUSTMENT "Number of Images" 
  (list 0 0 9000 1 100 0 SF-SPINNER)
 SF-ADJUSTMENT "Position X" 
  (list 0 0 9000 1 100 0 SF-SPINNER)
 SF-ADJUSTMENT "Position Y" 
  (list 0 0 9000 1 100 0 SF-SPINNER)
 SF-ADJUSTMENT "Width" 
  (list 0 0 9000 1 100 0 SF-SPINNER)
 SF-ADJUSTMENT "Height" 
  (list 0 0 9000 1 100 0 SF-SPINNER)
 )