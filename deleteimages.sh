#!/bin/bash 

file="./imagenesnoborrar.txt"
#Filtrado de imagenes de docker por nombre de la imagen (.Repository) y por dias de creadas 
docker images --filter=reference='*' --format "{{.Repository}} {{.ID}} {{.CreatedSince}}" | grep -i 'days' | awk '{ print $1 }' > images.txt
f="true" #inicializacion de la variale f para comparar si existe

#mostrar los archivos
echo "........................."
echo -e "Imagenes actuales del sistema:\n$(cat images.txt)"
echo "........................."
echo -e "Imagenes para no borrar:\n$(cat imagenesnoborrar.txt)"
echo "........................."
#bucle para comparar ID de imagenes un for para el archivo de imagenes actuales y un while readline para leer el archivo file que contiene las imagenes que no se deben borrar
for u in $(cat images.txt)
do	
          echo "___Imagen actual:$u" 
          a="$u"
      while read LINE; do
           b="$LINE" #lectura de la linea del archivo file
           echo "_________Imagen no borrar a comparar: $LINE "

	   if [ "$a" == "$b" ]; then
	      # echo "**NO BORRAR la imagen *** $a = $b "
            f=1 
    	   else
            # echo "------SI BORRAR, $a != $b"
	    c=0
	   fi
      done < $file;

 if [[ $f == "true" && $c == "0" ]]; then
	echo "La imagen: $a SI SE PUEDE BORRAR"
        docker rmi $a	
 elif [[ $f == "1" && $c == "0" ]]; then
	echo "La imagen: $a esta en el archivo de no borrar y NO SE PUEDE BORRAR"
 elif [[ $f == "true" && $c == "1" ]]; then
        echo "La imagen: $a esta en el archivo de no borrar NO SE PUEDE BORRAR"	
 fi
done



