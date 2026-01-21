from tkinter import *
from tkinter import messagebox, filedialog
import subprocess
from PIL import Image, ImageTk

global Nom_Archivo
imagen = None
imagenS = None
Nom_Archivo = None
#Funcion para enlazar al backend       

def Analizar():
    # Obtener el contenido del área de texto 
    for widget in Frame_S.winfo_children():
        widget.destroy()

    data = TxtBox_E.get("1.0", END)
    # Compilar y ejecutar el código Fortran
    comando = subprocess.run(
        ["gfortran", "-o", "..\Backend\main.exe", "..\Backend\main.f90"],  # compilación de Fortran
        check=True  # detener si hay un error en la compilación
    )
    resultado = subprocess.run(
        ["..\Backend\main.exe"],  # Ejecutable de Fortran
        input=data,  # la data que se manda a Fortran
        stdout=subprocess.PIPE,  # la data que viene de Fortran   
        text=True  # la salida se maneja como texto
    )
    output = resultado.stdout.strip()         

    datos = output.split(',')
    nombre = datos[0]   
    poblacion = datos[1]
    saturacion = datos[2]
    bandera = datos[3]
    # Redimensionar la imagen
    
    
    global imagenS
    try:
        imagenS = Image.open(bandera)
        imagenS = imagenS.resize((160, 100))
        img_tk = ImageTk.PhotoImage(imagenS)
        label2 = Label(Frame_S, image=img_tk, bg="Black")
        label2.image = img_tk
        label2.pack( side = BOTTOM)
        Label(Frame_S, text="Población: "+poblacion, font=("Arial", 12), bg="Black", fg="White").pack(side=BOTTOM)
        Label(Frame_S, text="Nombre: "+nombre, font=("Arial", 12), bg="Black", fg="White").pack(side=BOTTOM)
        Label(Frame_S, text="País seleccionado:", font=("Arial", 12), bg="Black", fg="White").pack(side=BOTTOM)
    except Exception as e:
        #right_text_area.insert(tk.END, f"\nError al cargar la imagen: {e}")   
        Label(Frame_S,text="Error: "+e, width="100", height="300", bg="Black").pack(side = BOTTOM)

    # Insertar la nueva salida en el área de texto derecha
    global imagen 
    
    try:
        imagen = Image.open(r"..\Out\graph.png")
        imagen = imagen.resize((800, 400))  # Redimensionar la imagen si es muy grande
        img_tk1 = ImageTk.PhotoImage(imagen)

        label1 = Label(Frame_S, image=img_tk1, bg="Black" )#.pack(side = TOP)
        label1.image = img_tk1
        label1.pack(side=TOP)
    except Exception as er:
        Label(Frame_S,text="Error: "+er,width="700", height="300", bg="Black").pack(side = TOP)

#Creación de ventana principal
Principal = Tk()
Principal.title("Lenguajes Formales y de Programación B-: PROYECTO 1")
Principal.iconbitmap("icono.ico")
Principal.resizable(1,1)    
Principal.geometry("1300x600")
Principal.config(padx=10, pady=35, bg="black" )

#Creacion de Frames
    #Frame Padre
Frame_F = Frame(Principal)
Frame_F.pack()
Frame_F.config(width="1270", height="530", bg="black")

    #Frame de entrada
Frame_E = Frame(Frame_F)
Frame_E.pack(side=LEFT)
Frame_E.config(width="395", height="530", bg="black")
    #Creacion de elementos dentro del Frame de entrada
TxtBox_E = Text(Frame_E)
TxtBox_E.pack(side=LEFT)
TxtBox_E.config(width="50", height="500", font=("Arial", 12), bg="Black", fg="White", insertbackground="White")
    #Creacion de srcollbar
scroll = Scrollbar(Frame_E)
scroll.pack(side=LEFT, fill=Y)
scroll.config(command=TxtBox_E.yview)
TxtBox_E.config(yscrollcommand=scroll.set)
    #Creacion de botón de analizar
Btn_E = Button(Frame_E)
Btn_E.pack(side=RIGHT)
Btn_E.config(text="Analizar", font=("Arial", 12), bg="Gray", fg="White", command=Analizar)
Btn_E.config(width="7", height="2")
    #Frame de salida
Frame_S = Frame(Frame_F)
Frame_S.pack(side=RIGHT)
Frame_S.config(width="730", height="530", bg="BLack")
    #Creacion de elementos dentro del Frame de salida
# TxtBox_S = Text(Frame_E)
# TxtBox_S.pack(side=RIGHT)
# TxtBox_S.config(width="50", height="500", font=("Arial", 12), bg="Black", fg="White", insertbackground="White")


#Creacion de barra de menu
menu_bar = Menu(Principal)
Principal.config(menu=menu_bar)
#Funciones del menu
def salir():
    resp = messagebox.askquestion("Salir", "¿Está seguro que desea salir?")
    if resp == "yes":
        Principal.quit()

def acerca_de():
    messagebox.showinfo("Acerca de", "Lenguajes Formales y de programación B-\n David Andrés Jimenez Paniagua\n 202004777")            
archivo_actual = None
def abrir():
   global archivo_actual
   file = filedialog.askopenfilename(
        title = "Seleccione un archivo",
        filetypes = (("ORG files", "*.ORG"), ("Todos los archivos", "*.*"))
    )
   if file:
       archivo_actual = file
   with open(file, "r") as f:
        messagebox.showinfo("Información", "Archivo cargado con éxito")
        contenido = f.read()
        TxtBox_E.delete(1.0, END)
        TxtBox_E.insert(1.0, contenido)

def guardar():
    global archivo_actual
    if archivo_actual:
        with open(archivo_actual, "w") as f:
            contenido = TxtBox_E.get(1.0, END)
            f.write(contenido)
    else:
        Guardar_Como()
            

def Guardar_Como():
    G_file = filedialog.asksaveasfilename(
        defaultextension=".ORG",
        filetypes = (("ORG files", "*.ORG"), ("Todos los archivos", "*.*")))
    if G_file is None:
        return
    else:
        G_file = open(G_file, "w")
        G_contenido = TxtBox_E.get(1.0, END)
        G_file.write(G_contenido)
        G_file.close()
    
    
    #Opciones del menu en cascada
menu_opciones = Menu(menu_bar, tearoff=0)
menu_bar.add_cascade(label="Menu", menu=menu_opciones)
menu_opciones.add_command(label="Abrir", command = abrir)
menu_opciones.add_command(label="Guardar", command = guardar)
menu_opciones.add_command(label="Guardar como", command = Guardar_Como)
    #Demás opciones del menu
menu_bar.add_command(label="Acerca de", command = acerca_de)
menu_bar.add_command(label="Salir", command= salir)


Principal.mainloop()
