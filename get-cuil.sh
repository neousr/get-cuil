#!/bin/bash
# This file was created on 2023-09-03

INPUT=input.csv

OLDIFS=$IFS

IFS=','

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

echo "DU,CUIL,APELLIDOS,NOMBRES,FECHA_NAC,SEXO" > output.csv

while read -r du lastname name date sex
do

    text="`curl -s 'https://www.anses.gob.ar/consultas/constancia-de-cuil?ajax_form=1&_wrapper_format=drupal_ajax' --compressed -X POST \
-H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/117.0' \
-H 'Accept: application/json, text/javascript, */*; q=0.01' \
-H 'Accept-Language: en-US,en;q=0.5' \
-H 'Accept-Encoding: gzip, deflate, br' \
-H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
-H 'X-Requested-With: XMLHttpRequest' \
-H 'Origin: https://www.anses.gob.ar' \
-H 'DNT: 1' \
-H 'Connection: keep-alive' \
-H 'Referer: https://www.anses.gob.ar/consultas/constancia-de-cuil' \
-H 'Cookie: visid_incap_2267324=fuZHoUCrTbqgkIWDxpZfo7APDmUAAAAAQUIPAAAAAAAtcxN8ZZDhXbMTmX3Hu0bL;nlbi_2267324=Dd12CcAFNzTQKWJRiQo30gAAAABQhZS9Q7IVZ3gq1wxNqGpK;incap_ses_1208_2267324=1Q90b05S0njwO02Rw67DEMB6DmUAAAAAMpY7KBaOavDWgQ26YB/RlQ==; visid_incap_2778330=IxQGahjYSoCj/3g9CIVCB7APDmUAAAAAQUIPAAAAAABRs5511XA7O7SzTRaj2nFs;incap_ses_1208_2778330=a08Od4NHpwYFPE2Rw67DEMB6DmUAAAAABqhWGKeVg51gaxjI6XU3vg==;nlbi_2267324_2147483392=nZQfLNa0uFlCec49iQo30gAAAACthpNw4UDcBQSq5RXwLvdV; persist_drupal_443=D02' \
-H 'Sec-Fetch-Dest: empty' \
-H 'Sec-Fetch-Mode: cors' \
-H 'Sec-Fetch-Site: same-origin' \
-H 'TE: trailers' \
--data-raw "type_doc=0029&cuil=&nro_doc=${du}&name=${name}&lastname=${lastname}&sexo=${sex}&date=${date}&recaptcha_response=03AFcWeA68xuu5rj8VdLy5CPO9LGROVc3zrc_iMYC7eOwunk_AHsJBzAJE2M9aj1gJ0JsNLE5XMch--wxNun8NFGQDse3yxCQPg_KuZmsmkpsAJJG4Bqbq1To7tPYdPPW_r6ZLANnA2RbOGLv5fB1FeSGoEenR1isZSffJ2q9YYVrrDn-dbwxNey4Us5qSrkG76hX59jvFZj5GnH1ikyt3Vf_e25vFyjC4Zc7qlLh-qEsVB4Lh82F9-5qGmzMq23NawS97hLHuimQ94SZi64KFImEgMAu6NvLrpyupamKSkOcFbVdSgmTNWq3uTfaKQsI-Ud4yNTQUGnH-psAeGwGMkbssAshjcpzARbkw8p4G9v_4RTtxATS-buGcqAC6wsd661O0vYleE7Z57coj3tNX4crVMQMqiQ2PGpwfkRLktVugdWmnBCKgBKHN9f72SCFyXusGdjZlwgjoZVpt1ugElk0x99C2uOYA8P2H5cGQ-fy3o0wdE3mxKUnNHDxodtGtW2AJYzlScuk48nR0bBZ4vshOFa7Vl5vJZHYHD4PiY0xA26o-YtkjRqA&form_build_id=form-DrCuuK2RhQG6mUHpsxN_h63qXbhe9EpW2nNKgzt6gA4&form_id=30&_triggering_element_name=op&_triggering_element_value=Consultar&_drupal_ajax=1&ajax_page_state%5Btheme%5D=ansessite&ajax_page_state%5Btheme_token%5D=&ajax_page_state%5Blibraries%5D=anses_consulta%2Fcuil%2Canses_feedback%2Ffeedback%2Cansessite%2Fbootstrap-scripts%2Cansessite%2Fglider%2Cansessite%2Fglobal-styling%2Cbootstrap%2Fpopover%2Cbootstrap%2Ftooltip%2Ccore%2Fdrupal.states%2Ccore%2Fhtml5shiv%2Cfontawesome%2Ffontawesome.svg.shim%2Cmatomo%2Fmatomo%2Csystem%2Fbase"`"

    cuil=$(echo ${text} | grep -wo '[0-9]\{11\}')

    # echo "$du,$cuil,$lastname,$name,$date,$sex" >> output.csv
    printf "$du,$cuil,$lastname,$name,$date,$sex\n" >> output.csv

done < <(tail -n +2 $INPUT)
IFS=$OLDIFS
