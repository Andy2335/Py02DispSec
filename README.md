# Proyecto corto II – Diseño digital sincrónico en HDL
# Implementación de un Sumador de 4 bits

## Escuela de Ingeniería Electrónica
**Curso:** EL-3307 Diseño Lógico

**Profesor:** Oscar Caravaca

**Semestre:** I Semestre 2026  

--- 
## Integrantes
- Andrés Obregón López
- Mariana Solano Gutiérrez
- Mariana Guerrero Morales
---

## Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays
- **HDL**: Hardware Description Language
- **SRC**: Source

## Herramientas Utilizadas
- **Lenguaje de descripción de hardware**: Verilog
- **Plataforma de desarrollo**: FPGA Nano Tang 9k
- **Multisim**: Para simulación de circuitos digitales
- **Digital works**: Para simulación de circuitos digitales
- **GTKWave**: Para verificación gráfica de señales en simulaciones

## Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

[1] [FZumb4do. open_source_fpga_environment](https://github.com/FZumb4do/open_source_fpga_environment.git) 

[2] [LUSHAYLABS. Tang Nano 9K: Getting Setup](https://learn.lushaylabs.com/getting-setup-with-the-tang-nano-9k/)

[3] [Sipeed Wiki — Tang Nano 9K](https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html)


## Objetivo
Implementar un sistema digital sincrónico que reciba dos cadenas de 4 bits, las sume utilizando un sumador de 4 bits y muestre el resultado en un display de 7 segmentos.

# Descripción general del sistema

En este proyecto se abordará el diseño e implementación de un sistema digital sincrónico que mediante un teclado matricial se ingresarán dos números de 4 bits cada uno. Ambos visualizados en el display de 4 x 7 segmentos. Luego estos números serán procesados por un sumador de 4 bits, el cual realizará la operación de suma y generará un resultado de máximo 4 bits. El resultado de la suma se visualizará en una cadena de 4 display de 7 segmentos.

[** Wiki ** ]() Pendiente de desarrollo.

## Estructura de la documentación
- `README.md`, Descripción general del proyecto
- `docs`, Especificaciones, esquemas, hojas de datos, imagenes, simulaciones, etc.
- `wiki`, Explicación detallada "Tutorial"
- `src`, Código fuente del proyecto, organizado en dispositivo y módulos
- `build`, Makerfile, scripts de compilación, archivos de configuración, etc.
- `constr`, Constraints - Definición de pines.
- `design`, Implementación lógica programada y funciones.
- `sim`, Testbenches y archivos de simulación.

## Jerarquía del sistema
- 4.1 Lector Teclado Hexadecimal - Diagrama de bloques y circuito lógico

    ### Diagrama de bloques:
    <img src="" width="700">

    ### Circuito lógico:
    <img src="" width="700">

    ### Visualización de Señales:
    <img src="" width="700">

- 4.2 Sumador - Diagrama de bloques y circuito lógico

    ### Diagrama de bloques:
    <img src="" width="700">

    ### Circuito lógico:
    <img src="" width="700">

    ### Visualización de Señales:
    <img src="" width="700">

- 4.3 Visualización DecoDisplay7SEG - Diagrama de bloques y circuito lógico

    ### Diagrama de bloques:
    <img src="" width="700">

    ### Circuito lógico:
    <img src="" width="700">

    ### Visualización de Señales:
    <img src="" width="700">


- Testbench y Simulación de Ondas
  [wiki]()

    El testbench se utilizó para verificar automáticamente el funcionamiento 

## Diagrama de Bloques:

El diagrama muestra la estructura funcional del módulo principal del sistema emisor. El dato de entrada de 4 bits es procesado por el codificador, el cual genera una palabra codificada de 7 bits, luego, esta señal es enviada al módulo de inserción de error, donde se puede alterar un bit según el valor de BitError, dando los bits finales del transmisor para que estos pasen al receptor. El dato original también es enviado al decodificador de 7 segmentos para su visualización en el display.

  <a href="https://raw.githubusercontent.com/Andy2335/Py01_DisLog_EmisorReceptorHamming/main/doc/imagenes/Diagrama.png">
  <img src="https://raw.githubusercontent.com/Andy2335/Py01_DisLog_EmisorReceptorHamming/main/doc/imagenes/Diagrama.png" width="700">
</a>

## Resultados
- Pendiente de desarrollo.



## Mejora en el sistema 
Pendiente de desarrollo.
[wiki]()




## Laboratorio  
Pendiente de desarrollo.
[wiki]()


## Conclusion
Pendiente de desarrollo.
