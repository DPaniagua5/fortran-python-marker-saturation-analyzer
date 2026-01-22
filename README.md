🌎 Read this in: English | Español

---

# Fortran–Python Analyzer

This project is a desktop application developed with **Python (Tkinter)** that integrates a **Fortran backend** for data processing.
The application allows users to input structured text, send it to a Fortran program for analysis, and visualize the results graphically.

The application analyzes an input language designed to describe graphs of continents and countries, where each country includes demographic data (population), a market saturation percentage, and an associated flag image. Using a deterministic finite automaton (DFA) implemented in Fortran, the system performs lexical analysis without regular expressions, validates the input, and generates token and error reports in HTML format.

If the lexical analysis is successful, the application determines the optimal country for opening a new office based on market saturation rules defined in the project specification, generates a Graphviz-based hierarchical graph (Graph → Continent → Country), and displays both the graph and the selected country information within the GUI.

This project emphasizes formal language analysis, automata theory, language integration, and backend–frontend communication between Fortran and Python.

---

## 🚀 Features

* Graphical User Interface built with Tkinter
* Backend processing implemented in Fortran
* Execution of Fortran code from Python using `subprocess`
* Data visualization through generated graphs
* Dynamic image loading (e.g., country flags)
* File handling (.ORG files)

---

## 🛠 Technologies Used

* **Python**

  * Tkinter
  * Pillow (PIL)
  * Subprocess
* **Fortran**
* **gfortran**
* Git & GitHub
* graphviz

---

## ▶️ How to Run

1. Make sure you have **Python 3** and **gfortran** installed.
2. Clone the repository:

   ```bash
   git clone https://github.com/DPaniagua5/fortran-python-marker-saturation-analyzer.git
   ```

3. Run the Python application:

   ```bash
   python main.py
   ```

4. Enter the input data and click **Analyze**.

   * Example of input data structure:

~~~Text
    grafica:{
        nombre:"Modelo Continental Beta";
        continente:{
        nombre: "Asia";
            pais:{
                nombre:"Japon";
                poblacion: 2352342;
                saturacion:60%;
                bandera: "C:\Banderas\jp.png";
            }
            pais:{
                bandera: "C:\Banderas\cn.png";
                nombre:"China";
                poblacion:1350000000 ;
                saturacion:84%;
            }
            pais:{
                saturacion:69%;
                poblacion: 2352342;
                nombre:"Korea";
                bandera: "C:\Banderas\kr.png";
            }
        }
        continente:{
        nombre: "America";
            pais:{
                nombre:"Canada";
                poblacion: 23423423;
                saturacion:44%;
                bandera: "C:\Banderas\ca.png";
            }
        }
        continente:{
        nombre: "Europa";
            pais:{
                nombre:"Alemania";
                poblacion: 2352342;
                saturacion:74%;
                bandera: "C:\Banderas\de.pngg";
            }
            pais:{
                bandera: "C:\Banderas\es.png";
                nombre:"Espana";
                poblacion:1350000000 ;
                saturacion:45%;
            }
            pais:{
                saturacion:100%;
                poblacion: 2352342;
                nombre:"Inglaterra";
                bandera: "C:\Banderas\gb-eng.png";
            }
        }
    continente:{
    nombre: "Oceania";
        pais:{
            nombre:"Islas Marshall";
            poblacion: 2352342;
            saturacion:8%;
            bandera: "C:\Banderas\mh.png";
        }
        pais:{
            nombre:"Islas Salomon";
            poblacion: 45000;
            saturacion:60%;
            bandera: "C:\Banderas\sb.png";
        }
    }
    continente:{
    nombre: "Africa";
        pais:{
            nombre:"Cabo Verde";
            poblacion: 35000;
            saturacion:43%;
            bandera: "C:\Banderas\cv.png";
        }
    }
    }

~~~

---

# Analizador Fortran–Python

Este proyecto es una aplicación de escritorio desarrollada en **Python (Tkinter)** que se integra con un **backend en Fortran** para el procesamiento de datos.
La aplicación permite ingresar texto estructurado, enviarlo a un programa en Fortran para su análisis y visualizar los resultados de forma gráfica.

El proyecto demuestra la interoperabilidad entre Python y Fortran, combinando una interfaz gráfica moderna con procesamiento eficiente en el backend.

---

## 🚀 Características

* Interfaz gráfica desarrollada con Tkinter
* Backend implementado en Fortran
* Ejecución de código Fortran desde Python usando `subprocess`
* Visualización de datos mediante gráficas
* Carga dinámica de imágenes (por ejemplo, banderas)
* Manejo de archivos (.ORG)

---

## 🛠 Tecnologías utilizadas

* **Python**

  * Tkinter
  * Pillow (PIL)
  * Subprocess
* **Fortran**
* **gfortran**
* Git & GitHub
* Graphviz

---

## ▶️ Cómo ejecutar el proyecto

1. Asegúrate de tener instalado **Python 3** y **gfortran**.
2. Clona el repositorio:

   ```bash
   git clone https://github.com/DPaniagua5/fortran-python-marker-saturation-analyzer.git
   ```

3. Ejecuta la aplicación:

   ```bash
   python main.py
   ```

4. Ingresa los datos y presiona **Analizar**.
    * Ejemplo de estructura de archivos soportados:

~~~Text
    grafica:{
        nombre:"Modelo Continental Beta";
        continente:{
        nombre: "Asia";
            pais:{
                nombre:"Japon";
                poblacion: 2352342;
                saturacion:60%;
                bandera: "C:\Banderas\jp.png";
            }
            pais:{
                bandera: "C:\Banderas\cn.png";
                nombre:"China";
                poblacion:1350000000 ;
                saturacion:84%;
            }
            pais:{
                saturacion:69%;
                poblacion: 2352342;
                nombre:"Korea";
                bandera: "C:\Banderas\kr.png";
            }
        }
        continente:{
        nombre: "America";
            pais:{
                nombre:"Canada";
                poblacion: 23423423;
                saturacion:44%;
                bandera: "C:\Banderas\ca.png";
            }
        }
        continente:{
        nombre: "Europa";
            pais:{
                nombre:"Alemania";
                poblacion: 2352342;
                saturacion:74%;
                bandera: "C:\Banderas\de.pngg";
            }
            pais:{
                bandera: "C:\Banderas\es.png";
                nombre:"Espana";
                poblacion:1350000000 ;
                saturacion:45%;
            }
            pais:{
                saturacion:100%;
                poblacion: 2352342;
                nombre:"Inglaterra";
                bandera: "C:\Banderas\gb-eng.png";
            }
        }
    continente:{
    nombre: "Oceania";
        pais:{
            nombre:"Islas Marshall";
            poblacion: 2352342;
            saturacion:8%;
            bandera: "C:\Banderas\mh.png";
        }
        pais:{
            nombre:"Islas Salomon";
            poblacion: 45000;
            saturacion:60%;
            bandera: "C:\Banderas\sb.png";
        }
    }
    continente:{
    nombre: "Africa";
        pais:{
            nombre:"Cabo Verde";
            poblacion: 35000;
            saturacion:43%;
            bandera: "C:\Banderas\cv.png";
        }
    }
    }

~~~

---

Para más información ver [Manuales](./Manuales/)
