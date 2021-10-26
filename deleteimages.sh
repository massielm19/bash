#!/bin/bash -v 
file="./imagenesnoborrar.txt"
#Filtrado de imagenes de docker por nombre de la imagen (.Repository) y por dias de creadas 
docker images --filter=reference='*' --format "{{.Repository}} {{.ID}} {{.CreatedSince}}" | grep -i 'days' | awk '{ print $1 }' > images
f="true" #inicializacion de la variale f para comparar si existe

#mostrar los archivos
echo -e "esto hay en el archivo de imagenes para no borrar:\n$(cat imagenesnoborrar.txt)"
echo -e "estas son las imagenes actuales del sistema:\n$(cat images.txt)"

#bucle para comparar ID de imagenes un for para el archivo de imagenes actuales y un while readline para leer el archivo file que contiene las imagenes que no se deben borrar
for u in $(cat images.txt)
do	
  echo "___Archivo images.txt: $u ____"
   a="$u"

        while read LINE; do
        b="$LINE" #lectura de la linea del archivo file
        echo "Archivo imagenesNoborrar.txt: $LINE "

	if [ "$a" == "$b" ]; then
	# echo "**NO BORRAR la imagen *** $a = $b "
         f=1 
    	else
         # echo "------SI BORRAR, $a != $b"
	  c=0
	fi
	done < $file;
# echo "aqui paso la primera lectura de todos"
# echo "f = $f "
# echo "c= $c"
if [[ $f == "true" && $c == "0" ]]; then
	echo "la imagen $a  SE PUEDE BORRAR"
	echo "docker rmi $a"
docker rmi $a	
elif [[ $f == "1" && $c == "0" ]]; then
	        echo "la imagen $a esta en el archivo de no borrar y NO SEPUED BORRAR"
elif [[ $f == "true" && $c == "1" ]]; then
        echo "la imagen $a esta en el archivo de no borrar NO SE PUEDE BORRAR"	
fi
done



