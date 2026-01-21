program analizador_lexico
    implicit none
    integer :: i, len, linea, columna, estado, puntero, numErrores, file_unit, ios, k, j, l
    integer :: espacio_texto, numTokens, tkn_sat, tkn_pob

    character(len=200) :: G_Nom
    character(len=100) :: C_Nom
    character(len=100) :: PS_Nom

     ! Definición de un tipo que almacena la información del error
    type :: ErrorInfo
        character(len=50) :: caracter  ! caracter
        character(len=200) :: descripcion  ! Descripción del error
        integer :: columna      ! Columna donde ocurrió el error
        integer :: linea        ! Línea donde ocurrió el error
    end type ErrorInfo

    ! Definición de un tipo que almacena la información del token
    type :: TokenInfo
        character(len=200) :: token
        character(len=5) :: descripcion_T
        integer :: columna_T      ! Columna del token
        integer :: linea_T        ! Línea del token
    end type TokenInfo

    ! Declaración de un arreglo de Continente
    type :: ContinenteInfo
        character(len=100) :: nombre
        integer :: numContinente
    end type ContinenteInfo

    ! Declaración de un arreglo de Pais
    type :: PaisInfo
        integer :: conti
        character(len=100) :: nombre
        character(len=100) :: poblacion
        character(len=100) :: saturacion
        character(len=100) :: bandera
    end type PaisInfo


    ! Declaración de un arreglo de errores de tipo ErrorInfo y de tokens de tipo TokenInfo
    type(ErrorInfo), dimension(200) :: errores
    type(TokenInfo), dimension(900) :: tokens
    type(ContinenteInfo), dimension(100) :: Continente
    type(PaisInfo), dimension(100) :: Pais  
    character(len=1) :: char 
    character(len=3000) :: tkn
    character(len=1), dimension(26) :: A 
    character(len=1), dimension(26) :: M
    character(len=1), dimension(4) :: S 
    character(len=1), dimension(1) :: C
    character(len=1), dimension(10) :: N
    character(len=1) :: char_error
    character(len=30) :: tok

    character(len=10000) :: buffer, contenido
    character(len=10) :: str_codigo_ascii, str_columna, str_linea
    ! Variables para el archivo HTML


    contenido = ''  ! Inicializa contenido vacío

    ! Lee el contenido desde la entrada estándar
    do
        read(*, '(A)', IOSTAT=ios) buffer
        if (ios /= 0) exit 
        contenido = trim(contenido) // trim(buffer) // new_line('a') ! concatenamos el 
        !contenido mas lo que viene en el buffer y como leemos por el salto de linea al final
    end do

    A = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
    M = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
    S = [':','{','}',';']
    C = ['"']
    N = ['0','1','2','3','4','5','6','7','8','9']
    
    k = 1
    j = 1
    l = 1
    tkn_sat = 0
    tkn_pob = 0 
    estado = 0
    puntero = 1
    columna = 1
    linea = 1
    numErrores = 0
    numTokens = 0
    tkn = ''

    len = len_trim(contenido) 

    do while (puntero <= len)
        char = contenido(puntero:puntero)

        if (ichar(char) == 10) then
            ! salto de linea
            columna = 1
            linea = linea + 1
            puntero = puntero + 1
        elseif (ichar(char) == 9) then
            ! tabulacion
            columna = columna + 4
            puntero = puntero + 1
        elseif (ichar(char) == 32) then
            ! espacio en blanco
            columna = columna + 1
            puntero = puntero + 1
        else
            select case (estado)
                case (0)
                    if (any(char == M)) then
                        estado = 1
                        columna = columna + 1
                        tkn = trim(tkn) // char
                    elseif(any(char == A))then
                        numErrores = numErrores + 1
                        columna = columna + 1
                        estado = 1
                        errores(numErrores) = ErrorInfo(char, "Error no debe iniciar en Mayuscula", columna, linea)
                    else 
                        numErrores = numErrores + 1
                        columna = columna + 1
                        estado = 1
                        errores(numErrores) = ErrorInfo(char, "caracter no pertenece", columna, linea)        
                    end if
                    puntero = puntero + 1
                case (1)
                    if (any(char == M)) then
                        estado = 1
                        columna = columna + 1
                        tkn = trim(tkn) // char
                    else if (any(char == S)) then
                        numTokens = numTokens + 1
                        tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                        columna = columna + 1
                        estado = 2
                        tkn = ""
                        tkn = trim(tkn) // char
                    else
                        numErrores = numErrores + 1
                        errores(numErrores) = ErrorInfo(char, "caracter no pertecene", columna, linea)
                        columna = columna + 1
                        estado = 1
                    end if
                    puntero = puntero + 1
                case (2)
                    if (any(char == S)) then
                        numTokens = numTokens + 1
                        tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                        tkn = ""
                        columna = columna + 1
                        ! agregar el char
                        tkn = trim(tkn) // char
                        numTokens = numTokens + 1
                        tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                        tkn = ""
                        estado = 3
                    else
                        numErrores = numErrores + 1
                        errores(numErrores) = ErrorInfo(char, "caracter no pertecene", columna, linea)
                        columna = columna + 1
                        estado = 2
                    end if
                    puntero = puntero + 1
                case (3)
                    puntero = puntero + 1
                    if (any(char == M)) then
                        estado = 3
                        columna = columna + 1
                        tkn = Trim(tkn) // char
                    elseif (any(char == A)) then
                        numErrores = numErrores + 1
                        estado = 3
                        errores(numErrores) = ErrorInfo(char,&
                        "Error: Palabra reservada en mayuscula,",&
                        columna, linea)
                        columna = columna + 1
                    else if (any(char == S) ) then
                        !Token Palabra reservada
                        numTokens = numTokens + 1
                        tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                        tkn = ""
                        !Token dos puntos   
                        tkn = trim(tkn) // char
                        columna = columna + 1
                        numTokens = numTokens + 1
                        tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                        tkn = ""  
                        estado = 3
                        !Apertura del nombre de la grafica
                    else if (any(char == C)) then
                        tkn = trim(tkn) // char
                        columna = columna + 1
                        estado = 4
                    else
                        numErrores = numErrores + 1
                         errores(numErrores) = ErrorInfo(char, "caracter no pertecene", columna, linea)
                        columna = columna + 1
                        estado = 3
                    end if
                    !Nombre de la grafica
                case (4)
                    tkn = trim(tkn) // char
                    estado = 4
                    columna = columna + 1
                    if (any(char == C)) then
                        numTokens = numTokens + 1
                        columna = columna + 1
                        tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                        G_Nom = TRIM(tkn)
                        tkn = ""
                        estado = 5
                    end if 
                    puntero = puntero + 1 
                case (5)
                    puntero = puntero + 1
                    if (any (char == S))then  
                        numTokens = numTokens + 1
                        columna = columna + 1
                        tkn = TRIM(tkn) // char
                        tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                        tkn = ""
                        estado = 6
                    else 
                        numErrores = numErrores + 1
                        errores(numErrores) = ErrorInfo(char, "caracter no pertecene", columna, linea)
                        columna = columna + 1
                        estado = 5
                    end if
             !continente
                case (6)
                    puntero = puntero + 1
                    if (any(char == M)) then
                        estado = 6
                        columna = columna + 1
                        tkn = Trim(tkn) // char
                    else if (any(char == A)) then
                        numErrores = numErrores + 1
                        estado = 6
                        errores(numErrores) = ErrorInfo(char,&
                        "Error: Palabra reservada en mayuscula.",&
                        columna, linea)
                        columna = columna + 1
                    else if (any(char == S)) then
                        !Token Palabra reservada
                        numTokens = numTokens + 1
                        tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                        tkn = ""
                        !Token dos puntos   
                        tkn = trim(tkn) // char
                        columna = columna + 1
                        numTokens = numTokens + 1
                        tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                        tkn = ""  
                        columna = columna + 1
                        estado = 7
                    else
                        numErrores = numErrores + 1
                        errores(numErrores) = ErrorInfo(char, "caracter no pertecene", columna, linea)
                        columna = columna + 1
                        estado = 6
                    end if
                case (7)
                    puntero = puntero + 1
                    if (any(char == S)) then
                        !Token llave abierta
                        numTokens = numTokens + 1
                        tkn = trim(tkn) // char 
                        tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                        tkn = ""
                        columna = columna + 1
                        estado = 8
                    else
                        numErrores = numErrores + 1
                        errores(numErrores) = ErrorInfo(char, "caracter no pertecene", columna, linea)
                        columna = columna + 1
                        estado = 7
                    end if
                case (8)
                    puntero = puntero + 1
                    if (any (char == M))then
                        columna =  columna + 1
                        tkn = TRIM(tkn) // char
                        estado = 8
                    else if (any( char == A))then
                        numErrores = numErrores + 1
                        estado = 8
                        errores(numErrores) = ErrorInfo(char,&
                        "Error: Palabra reservada en mayuscula.",&
                        columna, linea)
                        columna = columna + 1
                    else if (any( char == S))then
                        columna = columna + 1
                        !Token palabra reservada
                        numTokens = numTokens + 1
                        tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                        tkn = ""
                        !Token dos puntos
                        columna = columna + 1
                        tkn = trim(tkn) // char
                        numTokens = numTokens + 1
                        tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                        tkn = ""
                        estado = 9
                else     
                    numErrores = numErrores + 1
                    errores(numErrores) = ErrorInfo(char, "caracter no pertecene", columna, linea)
                    columna = columna + 1
                    estado = 8
                end if
            case (9)
                puntero = puntero + 1
                if(any(char == C))then
                    columna = columna + 1
                    tkn = TRIM(tkn) // char
                    estado = 10
                else 
                    numErrores = numErrores + 1
                    errores(numErrores) = ErrorInfo(char, "caracter no pertecene", columna, linea)
                    columna = columna + 1
                    estado = 9
                end if
                
            
            !Valida mayuscula en Continentes    
            case (10)
                puntero = puntero + 1
                if (any(char == A))then
                    tkn = TRIM(tkn) // char
                    columna = columna + 1
                    estado = 11 
                else if (any(char == M))then
                    numErrores = numErrores + 1
                    columna = columna + 1    
                    errores(numErrores) = ErrorInfo(char, &
                    "Error: el continente debe iniciar en mayuscula."&
                    , columna, linea)
                    estado = 11
                else 
                    numErrores = numErrores + 1
                    errores(numErrores) = ErrorInfo(char, "caracter no pertecene", columna, linea)
                    columna = columna + 1
                    estado = 11
                end if
            !Lo que viene a dentro del "" (Nombre del continente)
            case (11)
                puntero = puntero + 1
                if(any (char == M) .OR. any( char == A))then
                    tkn = TRIM(tkn) // char
                    columna = columna + 1
                    estado = 11
            ! Si se encuentra un " se termina va siguiente estado 
                else if (any(char == C))then
                    tkn = trim(tkn) // char
                    numTokens = numTokens + 1
                    tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                    !Se guarda el nombre del continente
                    C_Nom = tkn(2:len_trim(G_Nom)-1)
                    Continente(k)%nombre = TRIM(C_Nom)
                    Continente(k)%numContinente = k
                    C_Nom = ''
                    k = k + 1
                    tkn = ""
                    columna = columna + 1
                    estado = 12                
                else 
                    numErrores = numErrores + 1
                    errores(numErrores) = ErrorInfo(char, "caracter no pertecene", columna, linea)
                    columna = columna + 1
                    estado = 11
                end if
               !Valida que despues del nombre Continente venga un ;
            case (12)
                puntero = puntero + 1
                if (any(char == S ))then  
                    numTokens = numTokens + 1
                    columna = columna + 1
                    tkn = TRIM(tkn) // char
                    tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                    tkn = ""
                    estado = 13
                else 
                    numErrores = numErrores + 1
                    errores(numErrores) = ErrorInfo(char, "caracter no pertecene", columna, linea)
                    columna = columna + 1
                    estado = 12
                end if  
            !Inicia "Pais" (Recurrencia)
            case (13)
                    puntero = puntero + 1
                    if (any (char == M) )then  
                        columna = columna + 1
                        tkn = TRIM(tkn) // char
                        estado = 13 
                    else if (any(char == A))then
                        numErrores = numErrores + 1
                        columna = columna + 1
                        estado = 13
                        errores(numErrores) = ErrorInfo(char, &
                        "Error: Palabra reservada en mayuscula."&
                        , columna, linea)
                    else if (char == ":")then
                        !Token PR "pais"
                        numTokens = numTokens + 1
                        columna = columna + 1
                        tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                        tkn = ""
                        !token dos puntos    
                        tkn = trim(tkn) // char
                        numTokens = numTokens + 1
                        columna = columna + 1
                        tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                        tkn = ""
                        estado = 14
                    else 
                        numErrores = numErrores + 1
                        errores(numErrores) = ErrorInfo(char, "caracter no pertecene", columna, linea)
                        columna = columna + 1
                        estado = 13
                end if 
                !Valida que despues de los dos puntos venga un {
            case (14)
                puntero = puntero + 1
                if (char == "{") then 
                    !Token simbolo {
                    tkn = trim(tkn) // char
                    columna = columna + 1
                    numTokens = numTokens + 1
                    tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                    tkn = ""  
                    estado = 15
                else
                    numErrores = numErrores + 1
                    errores(numErrores) = ErrorInfo(char, "caracter no pertecene", columna, linea)
                    columna = columna + 1
                    estado = 14
                end if
                !A partir de aca acepta las características del pais hasta que encuentre ":"
            case (15)
                puntero = puntero + 1
                if (any(char == M)) then
                    columna = columna + 1
                    tkn = TRIM(tkn) // char
                    estado = 15
                else if (char == ":") then
                    numTokens = numTokens + 1
                    columna = columna + 1
                    tokens(numTokens) = TokenInfo(TRIM(tkn),"token", columna, linea)

                    if(tkn == "nombre")then
                        j = 1
                    else if(tkn == "poblacion")then
                        j = 2
                    else if(tkn == "saturacion")then
                        j = 3
                    else if(tkn == "bandera")then
                        j = 4
                    end if
                    
                    tkn = ""
                    tkn = trim(tkn) // char
                    numTokens = numTokens + 1
                    columna = columna + 1
                    tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                    tkn = ""
                    estado = 16
                else if (char == "}")then
                    estado = 17
                    columna = columna + 1
                    tkn = trim(tkn) // char
                    numTokens = numTokens + 1
                    columna = columna + 1
                    tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                    tkn = ""
                    l = l + 1
                else if(any(char == A))then
                    numErrores = numErrores + 1
                    errores(numErrores) = ErrorInfo(char,&
                     "Error: Palabra reservada en mayuscula."&
                     , columna, linea)
                    columna = columna + 1
                    estado = 15
                else
                    numErrores = numErrores + 1
                    errores(numErrores) = ErrorInfo(char, "caracter no pertecene ", columna, linea)
                    columna = columna + 1
                    estado = 15 
                end if

            !Puede venir cualquier cosa, hasta que halle un ;
            case (16)
                puntero = puntero + 1
                tkn = trim(tkn)// char
                estado = 16
                columna = columna + 1
                    if (char == ";")then 
                    tkn = tkn(1:len_trim(tkn)-1)
                    numTokens = numTokens + 1
                    columna = columna + 1
                    tokens(numTokens)    = TokenInfo(TRIM(tkn),"token", columna, linea)
                    
                    if(j == 1)then
                        Pais(l)%conti = k-1
                        Pais(l)%nombre = TRIM(tkn)
                    else if(j == 2)then
                        !write(tkn_pob, '(I0)')tkn
                        Pais(l)%conti = k-1
                        Pais(l)%poblacion = TRIM(tkn)
                        !tkn_pob = 0
                    else if(j == 3)then
                        Pais(l)%conti = k-1
                        tkn = tkn(1:len_trim(tkn)-1)
                        !write(tkn_sat, '(I0)') TRIM(tkn)
                        Pais(l)%saturacion = TRIM(tkn)
                        !tkn_sat = 0
                    else if(j == 4)then
                        Pais(l)%conti = k-1
                        Pais(l)%bandera = TRIM(tkn)
                    end if
                    
                    j = 0
                    tkn = ""
                    tkn = trim(tkn) // char
                    numTokens = numTokens + 1
                    columna = columna + 1
                    tokens(numTokens) = TokenInfo(TRIM(tkn), "token", columna, linea)
                    tkn = ""
                    !Devuelve al estado anterior para la siguiente caracteristica 
                    estado = 15
                    !Si ya no hay más caracteristias se cierra la llave     
                end if 

                !Valida que despues del cierre del corchete pueda venir:
                !1. Otro } (Cierre del continente)
                !2. Una letra (Otro bloque Pais)
              case (17)
                  puntero = puntero + 1
                  if (char == "}")then
                      numTokens = numTokens + 1
                      columna = columna + 1
                      tokens(numTokens) = TokenInfo(TRIM(char), "token", columna, linea)
                      tkn = ""
                      estado = 18
                  else if (any(char == M))then
                      tkn = trim(tkn) // char
                      columna = columna + 1
                      estado = 13
                  else if (any(char == A))then
                      numErrores = numErrores + 1
                      estado = 13
                      errores(numErrores) = ErrorInfo(char,&
                      "Error: Palabra reservada en mayuscula.",&
                      columna, linea)
                      columna = columna + 1
                    else 
                    numErrores = numErrores + 1
                    errores(numErrores) = ErrorInfo(char, "caracter no pertecene ", columna, linea)
                    columna = columna + 1
                    estado = 17
                  end if
                
                !Se confirma que si despues del bloque continente se cierra "}"
            case (18)
                puntero = puntero + 1
                if (char == "}")then
                    columna = columna + 1
                    numTokens = numTokens + 1
                    tokens(numTokens) = TokenInfo(TRIM(char), "token", columna, linea)
                    tkn = ""
                    estado = 19
                else if (any(char == M)) then
                    columna = columna + 1
                    tkn = trim(tkn) // char
                    estado = 6
                else if (any(char == A)) then
                    numErrores = numErrores + 1
                    columna = columna + 1
                    estado = 6
                    errores(numErrores) = ErrorInfo(char,&
                    "Error: Palabra reservada en mayuscula."&
                    , columna, linea)
                else
                    numErrores = numErrores + 1
                    errores(numErrores) = ErrorInfo(char, "caracter no pertecene ", columna, linea)
                    columna = columna + 1
                    estado = 18
                end if
            
                !Valida el último }
            case (19)
                puntero = puntero + 1
                if (char == "}")then
                    columna = columna + 1
                    numTokens = numTokens + 1
                    tokens(numTokens) = TokenInfo(TRIM(char), "token", columna, linea)
                    tkn = ""
            else 
                numErrores = numErrores + 1
                errores(numErrores) = ErrorInfo(char, "caracter no pertecene", columna, linea)
                columna = columna + 1
                
            end if
            end select
        end if
    end do

    ! Si hay errores, se crea el archivo errores HTML
    if (numErrores > 0) then
      call generar_html_errores(numErrores, errores)
    ! Si no hay errores se crea el archivo de tokens y el gráfico
    else
      call generar_html_tokens(numTokens, tokens)
      call graficar(G_Nom, Continente, Pais)
      call generar_img
    end if

contains

   subroutine generar_html_errores(numErrores, errores)
        implicit none
        integer, intent(in) :: numErrores
        type(ErrorInfo), intent(in) :: errores(numErrores)
        character(len=100000) :: html_content
        character(len=200) :: str_descripcion, str_columna, str_linea,char_error, str_no

        integer :: file_unit, ios, i

        ! Si hay errores, se crea el archivo HTML
       if (numErrores > 0) then
    ! Abrir el archivo para escribir
            open(unit=file_unit, file="..\Out\errores.html", status="replace", action="write", iostat=ios)
            if (ios /= 0) then
                print *, "Error al crear el archivo HTML Errores."
            else
                ! Escribir la cabecera del HTML directamente al archivo
                write(file_unit, '(A)') '<!DOCTYPE html>' // new_line('a')
                write(file_unit, '(A)') '<html><head>'&
                //'<title>Errores</title> <style>' // new_line('a')
                write(file_unit, '(A)') 'body {Background-color: #d8d3d3 }' // new_line('a')
                write(file_unit, '(A)') 'h2 { color: #000000; text-align: center; }' // new_line('a')
                write(file_unit, '(A)') 'table { font-family: Arial, sans-serif;'
                write(file_unit, '(A)') 'border-collapse: collapse; width: 100%; }' // new_line('a')
                write(file_unit, '(A)') 'td, th { border: 2px solid #000000; text-align: left; padding: 8px; }' // new_line('a')
                write(file_unit, '(A)') 'th {background-color: #EC7C30}' // new_line('a')
                write(file_unit, '(A)') 'tr:nth-child(odd) { background-color: #FAE4D4 ; }' // new_line('a')
                write(file_unit, '(A)') 'tr:nth-child(even)  { background-color: #FFFFFF} ' // new_line('a')
                write(file_unit, '(A)') '</style></head><body><h2>Tabla de Errores</h2>' // new_line('a')
                write(file_unit, '(A)') '<table><tr><th>No.</th><th>Carácter</th><th>Descripcion' 
                write(file_unit, '(A)') '</th><th>Columna</th><th>Línea</th></tr>' // new_line('a')

                ! Bucle para formatear cada código ASCII y cada columna

                ! Bucle para agregar filas a la tabla
                do i = 1, numErrores
                    write(str_no, '(I0)') i
                    write(str_descripcion, '(A)') trim(errores(i)%descripcion)
                    write(str_columna, '(I0)') errores(i)%columna
                    write(str_linea, '(I0)')  errores(i)%linea
                    write(char_error, '(A)') trim(errores(i)%caracter)
         
                    ! Escribir cada fila directamente al archivo

                    write(file_unit, '(A)') '<tr><td>' // str_no // '<td>' // char_error &
                    // '</td><td>' // trim(str_descripcion) // & 
                    '</td><td>' // trim(str_columna) // '</td><td>'&
                     // trim(str_linea) // '</td></tr>' // new_line('a')
                end do

                ! Cerrar la tabla y el HTML
                write(file_unit, '(A)') '</table></body></html>'
                close(file_unit)
            end if
        else
            print *, "No hay errores en el código."
        end if
    end subroutine generar_html_errores

    subroutine generar_html_tokens(numTokens, tokens)
        implicit none
        integer, intent(in) :: numTokens
        type(TokenInfo), intent(in) :: tokens(numTokens)
        character(len=100000) :: html_content
        character(len=500) :: str_descripcion, str_columna, str_linea,char_error,str_no_T
        character(len=1) :: last_char
        integer :: file_unit, ios, i

        ! Si no hay errores, se crea el archivo HTML
       if (numErrores == 0) then
    ! Abrir el archivo para escribir
            open(unit=file_unit, file="..\Out\tokens.html", status="replace", action="write", iostat=ios)
            if (ios /= 0) then
                print *, "Error al crear el archivo HTML Tokens."
            else
                ! Escribir la cabecera del HTML directamente al archivo
                write(file_unit, '(A)') '<!DOCTYPE html>' // new_line('a')
                write(file_unit, '(A)') '<html><head>' &
                // '<title>Tokens</title><style>' // new_line('a')
                write(file_unit, '(A)') 'body {Background-color: #d8d3d3 }' // new_line('a')
                write(file_unit, '(A)') 'h2 { color: #000000; text-align: center; }' // new_line('a')
                write(file_unit, '(A)') 'table { font-family: Arial, sans-serif;'
                write(file_unit, '(A)') 'border-collapse: collapse; width: 100%; }' // new_line('a')
                write(file_unit, '(A)') 'td, th { border: 2px solid #000000; text-align: left; padding: 8px; }' // new_line('a')
                write(file_unit, '(A)') 'th {background-color: #5B9BD4}' // new_line('a')
                write(file_unit, '(A)') 'tr:nth-child(odd) { background-color: #DEEBF6 ; }' // new_line('a')
                write(file_unit, '(A)') 'tr:nth-child(even) { background-color: #FFFFFF; }' // new_line('a')
                write(file_unit, '(A)') '</style></head><body><h2>Tabla de Tokens</h2>' // new_line('a')
                write(file_unit, '(A)') '<table><tr><th>No.</th><th>Lexema</th><th>Tipo' 
                write(file_unit, '(A)') '</th><th>Columna</th><th>Fila</th></tr>' // new_line('a')

                ! Bucle para formatear cada código ASCII y cada columna
                
                !last_char = tokens(i)%token(len_trim(tokens(i)%token):len_trim(tokens(i)%token))
                ! Bucle para agregar filas a la tabla
                do i = 1, numTokens
                    write(str_no_T, '(I10)') i
                    last_char = tokens(i)%token(len_trim(tokens(i)%token):len_trim(tokens(i)%token))    
                if(any(last_char == N))then
                    write(str_descripcion, '(A)') 'Número'
                    last_char = ""
                else if(last_char == "%")then
                    write(str_descripcion, '(A)') 'Porcentaje'
                    last_char = ""
                    else
                    if (trim(tokens(i)%token) == 'grafica' .OR. trim(tokens(i)%token) == 'nombre'&
                        .OR. trim(tokens(i)%token) == 'continente' .OR. trim(tokens(i)%token) == 'pais'&
                        .OR. trim(tokens(i)%token) == 'poblacion' .OR. trim(tokens(i)%token) == 'saturacion'&
                        .OR. trim(tokens(i)%token) == 'bandera') then
                        write(str_descripcion, '(A)') 'Palabra reservada'
                    else if (trim(tokens(i)%token) == ':') then
                        write(str_descripcion, '(A)') 'Dos puntos'
                    else if (trim(tokens(i)%token) == '{') then
                        write(str_descripcion, '(A)') 'Llave de apertura'
                    else if (trim(tokens(i)%token) == '}') then
                        write(str_descripcion, '(A)') 'Llave de cierre'
                    else if (any(N == tokens(i)%token)) then
                        write(str_descripcion, '(A)') 'Número'
                    else if (trim(tokens(i)%token) == ';') then
                        write(str_descripcion, '(A)') 'Punto y coma'
                    else
                        write(str_descripcion, '(A)') 'Cadena'
                    end if
                    end if
                    !write(str_descripcion, '(A)') trim(tokens(i)%descripcion_T)
                    write(str_columna, '(I0)') tokens(i)%columna_T
                    write(str_linea, '(I0)')  tokens(i)%linea_T
                    write(tok, '(A)') trim(tokens(i)%token)
                    ! Escribir cada fila directamente al archivo
                    write(file_unit, '(A)') '<tr><td>' // str_no_T // '</td><td>'&
                     // tok // &
                     '</td><td>' // trim(str_descripcion) // & 
                    '</td><td>' // trim(str_columna) // '</td><td>'&
                     // trim(str_linea) // '</td></tr>' // new_line('a')
                end do

                ! Cerrar la tabla y el HTML
                write(file_unit, '(A)') '</table></body></html>'
                close(file_unit)
                
            end if
            
        else
            print *, "No hay errores en el código."
        end if
    end subroutine generar_html_tokens
    
subroutine graficar(G_Nom, Continente, Pais)
        implicit none
        integer :: ios
        type(ContinenteInfo), intent(in) :: Continente(k)
        type(PaisInfo), intent(in) :: Pais(l)
        character(len=100), intent(in) :: G_Nom 
        character(len=100) :: P_nom
        character(len=100) :: str_i
        character(len=100) :: str_j
        character(len=100) :: str_sat
        character(len=100) :: T_sat_cont
        integer :: int_saturacion, sat_cont, T_sat_paises, t, Aux_sat1, Aux_sat2, z, minimo, C_min
        character(len=100) :: Graph
        character(len=100) :: C_Nom
        character(len=100) :: A_ruta

        !Pais seleccionado:
    type :: PaisSelec
        character(len=100) :: nombre
        character(len=100) :: poblacion
        character(len=100) :: saturacion
        character(len=100) :: bandera
    end type PaisSelec

    integer,dimension(100) :: S_P
    integer, dimension(100) :: S_C

    type(PaisSelec), dimension(1) :: PaisSel

        
        open(unit=10, file="..\Out\graph.dot", status="replace", iostat=ios)
        if (ios /= 0) then
            print*, "Error abrierto el archivo: "
        end if
        Graph = G_Nom(2:len_trim(G_Nom)-1)

        write(10, *) "    digraph G{   "
        write(10, *) "    Nombre [label="" ",TRIM(Graph)," "", shape = diamond];"
        write(10, *) "    node [shape=box, style=filled];"
        !i es para continentes
        Aux_sat1 = 0
        do i = 1, k - 1
            T_sat_paises = 0
            write(str_i, '(I0)') i
                !j es para paises
                t = 0    
            do j = 1, l - 1   
                write(str_j, '(I0)') j
                P_nom = Pais(j)%nombre
                P_nom = P_nom(2:len_trim(P_Nom)-1)
                if (continente(i)%numContinente == pais(j)%conti) then    
                    str_sat = TRIM(Pais(j)%saturacion)
                    read(Pais(j)%saturacion,*)  int_saturacion
                    S_P(j) = int_saturacion
                    if (int_saturacion < 0)then
                        write(10, *) "    Pais",TRIM(str_j), "[label= """ ,TRIM(P_nom),&
                        "\n ERROR: NO SE ACEPTA SATURACION NEGATIVA""];"
                        write(10, *) "    Continente",TRIM(str_i), " -> Pais",TRIM(str_j),";"
                        write(10, *) "    Pais",TRIM(str_j), " [fillcolor=white];"
                        t = t + 1

                    else if (int_saturacion <= 15)then
                        write(10, *) "    Pais",TRIM(str_j), "[label= """ ,TRIM(P_nom),"\n",TRIM(Pais(j)%saturacion), "%""];"
                        write(10, *) "    Continente",TRIM(str_i), " -> Pais",TRIM(str_j),";"
                        write(10, *) "    Pais",TRIM(str_j), " [fillcolor=white];"
                        t = t + 1

                    else if(int_saturacion <= 30)then
                        write(10, *) "    Pais",TRIM(str_j), "[label= """ ,TRIM(P_nom),"\n",TRIM(Pais(j)%saturacion), "%""];"
                        write(10, *) "    Continente",TRIM(str_i), " -> Pais",TRIM(str_j),";"
                        write(10, *) "    Pais",TRIM(str_j), " [fillcolor=blue];"
                        t = t + 1

                    else if(int_saturacion <= 45)then
                        write(10, *) "    Pais",TRIM(str_j), "[label= """ ,TRIM(P_nom),"\n",TRIM(Pais(j)%saturacion), "%""];"
                        write(10,    *) "    Continente",TRIM(str_i), " -> Pais",TRIM(str_j),";"
                        write(10, *) "    Pais",TRIM(str_j), " [fillcolor=green];"
                        t = t + 1

                    else if(int_saturacion <= 60)then
                        write(10, *) "    Pais",TRIM(str_j), "[label= """ ,TRIM(P_nom),"\n",TRIM(Pais(j)%saturacion), "%""];"
                        write(10, *) "    Continente",TRIM(str_i), " -> Pais",TRIM(str_j),";"
                        write(10, *) "    Pais",TRIM(str_j), " [fillcolor=yellow];"    
                        t = t + 1

                    elseif(int_saturacion <= 75)then
                        write(10, *) "    Pais",TRIM(str_j), "[label= """ ,TRIM(P_nom),"\n",TRIM(Pais(j)%saturacion), "%""];"
                        write(10, *) "    Continente",TRIM(str_i), " -> Pais",TRIM(str_j),";"
                        write(10, *) "    Pais",TRIM(str_j), " [fillcolor=orange];"
                        t = t + 1

                    else if(int_saturacion <= 100)then
                        write(10, *) "    Pais",TRIM(str_j), "[label= """ ,TRIM(P_nom),"\n",TRIM(Pais(j)%saturacion), "%""];"
                        write(10, *) "    Continente",TRIM(str_i), " -> Pais",TRIM(str_j),";"
                        write(10, *) "    Pais",TRIM(str_j), " [fillcolor=red];"
                        t = t + 1

                    elseif(int_saturacion > 100)then
                        write(10, *) "    Pais",TRIM(str_j), "[label= """ ,TRIM(P_nom),"\n ERROR: SATURACION MAYOR AL 100%""];"
                        write(10, *) "    Continente",TRIM(str_i), " -> Pais",TRIM(str_j),";"
                        write(10, *) "    Pais",TRIM(str_j), " [fillcolor=white];"
                        t = t + 1
                    end if
                    T_sat_paises = T_sat_paises + int_saturacion
                end if
                
            end do

            sat_cont = T_sat_paises / t
            write(T_sat_cont, '(I0)') sat_cont
            C_Nom = Continente(i)%nombre(1:len_trim(Continente(i)%nombre)-1)

            if (sat_cont < 0)then
                write(10, *) "    Continente",TRIM(str_i), "[label= """ ,TRIM(C_nom),&
                "\n ERROR: NO SE ACEPTA SATURACION NEGATIVA""];"
                write(10, *) "    Nombre -> Continente",TRIM(str_i),";"
                write(10, *) "    Continente",TRIM(str_i), " [fillcolor=white];"

            else if (sat_cont <= 15)then
                write(10, *) "    Continente",TRIM(str_i), "[label= """ ,TRIM(C_nom),&
                "\n", TRIM(T_sat_cont),"%""];"
                write(10, *) "    Nombre -> Continente",TRIM(str_i),";"
                write(10, *) "    Continente",TRIM(str_i), " [fillcolor=white];"

            else if(sat_cont <= 30)then
                write(10, *) "    Continente",TRIM(str_i), "[label= """ ,TRIM(C_nom),&
                "\n", TRIM(T_sat_cont),"%""];"
                write(10, *) "    Nombre -> Continente",TRIM(str_i),";"
                write(10, *) "    Continente",TRIM(str_i), " [fillcolor=blue];"

            else if(sat_cont <= 45)then
                write(10, *) "    Continente",TRIM(str_i), "[label= """ ,TRIM(C_nom),&
                "\n", TRIM(T_sat_cont),"%""];"
                write(10, *) "    Nombre -> Continente",TRIM(str_i),";"
                write(10, *) "    Continente",TRIM(str_i), " [fillcolor=green];"

            else if(sat_cont <= 60)then
                write(10, *) "    Continente",TRIM(str_i), "[label= """ ,TRIM(C_nom),&
                "\n", TRIM(T_sat_cont),"%""];"
                write(10, *) "    Nombre -> Continente",TRIM(str_i),";"
                write(10, *) "    Continente",TRIM(str_i), " [fillcolor=yellow];"

            elseif(sat_cont <= 75)then
                write(10, *) "    Continente",TRIM(str_i), "[label= """ ,TRIM(C_nom),&
                "\n", TRIM(T_sat_cont),"%""];"
                write(10, *) "    Nombre -> Continente",TRIM(str_i),";"
                write(10, *) "    Continente",TRIM(str_i), " [fillcolor=orange];"

            else if(sat_cont <= 100)then
                write(10, *) "    Continente",TRIM(str_i), "[label= """ ,TRIM(C_nom),&
                "\n", TRIM(T_sat_cont),"%""];"
                write(10, *) "    Nombre -> Continente",TRIM(str_i),";"
                write(10, *) "    Continente",TRIM(str_i), " [fillcolor=red];"

            elseif(sat_cont > 100)then
                write(10, *) "    Continente",TRIM(str_i), "[label= """ ,TRIM(C_nom),&
                "\n ERROR: SATURACION MAYOR AL 100%""];"
                write(10, *) "    Nombre -> Continente",TRIM(str_i),";"
                write(10, *) "    Continente",TRIM(str_i), " [fillcolor=white];"

            end if
            S_C(i) = sat_cont
            sat_cont = 0
        end do 
            
        WRITE(10, *) " }"
        
        minimo = S_P(1)
        C_min = S_C(1)
        do i = 1, l-1
            if (S_P(i) < minimo) then
                minimo = S_P(i)
                Aux_sat1 = i
            else if(S_P(i) == minimo)then
                do j = 1, k-1
                    if(S_C(Pais(i)%conti) < S_C(i)) then
                        PaisSel(1)%nombre = Pais(i)%nombre
                        PaisSel(1)%poblacion = Pais(i)%poblacion
                        PaisSel(1)%saturacion = Pais(i)%saturacion
                            A_ruta = Pais(i)%bandera
                        A_ruta = A_ruta(2:len_trim(A_ruta)-1)
                        PaisSel(1)%bandera = A_ruta
                        Aux_sat1 = i
                        !PaisSel(1)%bandera = Pais(Pais(i)%conti)%bandera
                    else 
                        PaisSel(1)%nombre = Pais(Pais(i)%conti)%nombre
                        PaisSel(1)%poblacion = Pais(Pais(i)%conti)%poblacion
                        PaisSel(1)%saturacion = Pais(Pais(i)%conti)%saturacion

                        A_ruta = Pais(Pais(i)%conti)%bandera
                        A_ruta = A_ruta(2:len_trim(A_ruta)-1)
                        PaisSel(1)%bandera = A_ruta
                        Aux_sat1 = i
                    end if
                end do
            end if
        end do

        PaisSel(1)%nombre = Pais(Aux_sat1)%nombre
        PaisSel(1)%poblacion = Pais(Aux_sat1)%poblacion
        PaisSel(1)%saturacion = Pais(Aux_sat1)%saturacion
        
        A_ruta = Pais(Aux_sat1)%bandera
        A_ruta = A_ruta(2:len_trim(A_ruta)-1)
        PaisSel(1)%bandera = A_ruta

        ! write(10, *) "Pais Seleccionado: ",TRIM(PaisSel(1)%nombre),",",&
        ! TRIM(PaisSel(1)%poblacion),",",&
        ! TRIM(PaisSel(1)%saturacion),",",&
        ! TRIM(PaisSel(1)%bandera)
        
        write(*,*) TRIM(PaisSel(1)%nombre),",",&
        TRIM(PaisSel(1)%poblacion),",",&
        TRIM(PaisSel(1)%saturacion),",",&
        TRIM(PaisSel(1)%bandera)
        close(10)
    
    end subroutine graficar
    
    subroutine generar_img
        implicit none
        character(len=250) :: comando
        comando = "dot -Tpng  ..\Out\graph.dot -o ..\Out\graph.png"
        call system(comando)
    end subroutine generar_img

    function itoa(num) result(str)
        implicit none
        integer, intent(in) :: num
        character(len=20) :: str

        write(str, '(I0)') num  ! Convierte el entero 'num' a cadena
    end function itoa

end program analizador_lexico