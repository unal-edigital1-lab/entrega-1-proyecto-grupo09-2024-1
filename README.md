# Entrega 1 Proyecto Tamagotchi
## Integrantes 
* Julian David Monsalve Sanchez
* Jonathan Andres Jimenez Trujillo
* Daniel Esteban Hostos
## Características Generales

El dispositivo cuenta con los siguientes botones para la interacción del usuario:

- Reset
- Alimentar
- Jugar
- Test


Y los siguientes sensores de entorno para interactuar con el mundo real:

- Sensor digital de sonido KY-037
  ![sound-detection-sensor-module-analog-type-tech3254-2910-1](https://github.com/user-attachments/assets/9c4fbb6a-abda-4235-be87-2685cf2ae8f3)

- Sensor digital de luz LM393
  ![1200](https://github.com/user-attachments/assets/887f02c0-d403-42a8-85f1-0686fdd790e3)

Para mostrar la información se usará una pantalla monocromática Nokia 5110 de 84x48 pixeles
  ![PANTALLA-NOKIA-5110](https://github.com/user-attachments/assets/d969fd96-ef69-4490-abf3-62f4e16ec10e)



## Descripción General

La mascota cuenta 4 variables cuyo estado depende de las interacciones del usuario a lo largo del tiempo, al llegar cualquiera de ellas a cero, la mascota muere y debe reiniciarse el juego:

Se considera que un juego inicia cuando:

- Se ha presionado el botón Reset durante 5 segundos.
- Estando en modo Test, se presiona el botón Test durante 5 segundos.

La mascota cuenta con las siguientes características:

- Salud - Medida en corazones, con un máximo de 3, representa el nivel combinado de bienestar de la mascota en base a su felicidad, energía y hambre
- Felicidad - Medida en caritas felices, con un máximo de 3, si llega a cero la mascota muere de depresión
- Energía - Medida en niveles de batería, con máximo de 4, si llega a cero la mascota muere de cansancio
- Hambre - Medida en huesos, con un máximo de 3, si llega a cero la mascota muere de inanición.

La mascota se ve afectada por dos variables del mundo real: sonido y luz

### Tiempo

Inicialmente 1 día en tiempo de juego es equivalente a un día real, sin embargo esta equivalencia puede alterarse con el botón Reset, este botón únicamente reinicia la partida al mantenerse pulsado durante 5 segundos, pero al presionarlo una vez de manera breve se puede variar entre 4 aceleradores tiempo de juego, los cuales son: X1, X2, X4, X8 y X16. 

### Felicidad, Energía y Hambre

La disminución de las variables se lleva a cabo de la siguiente manera:

- Su nivel de Felicidad disminuye a un ritmo de una carita feliz cada 6 horas de tiempo de juego desde la última vez que jugó.
- Su nivel de Energía disminuye a un ritmo de un nivel cada 2 horas de tiempo de juego desde la última vez que durmió.
- Su nivel de Hambre disminuye a un ritmo de un hueso cada 8 horas de tiempo de juego desde la última vez que fue alimentado. 

Como limitante de dificultad, la mascota no puede ser alimentada más de una vez por hora en tiempo de juego.

Así mismo, la mascota debe tener un plazo de descanso de al menos dos horas antes de jugar nuevamente.

Un nivel de energía es recuperado cada 3 horas de sueño consecutivo que logre la mascota.

### Luz y Sonido

La mascota se ve afectada por dos variables que dependen de sensores digitales de luz y sonido, estas variables son digitales de 1 bit, por lo cual cada una cuenta con tan solo dos estados: oscuridad, luz para el sensor de luminosidad y silencio, sonido para el sensor de sonido.

La sensibilidad de los sensores para obtener un 1 lógico en el juego está dictada por un potenciómetro que debe ser ajustado para una dificultad de juego abierta a discusión.

### Dormido, Despierto

La mascota inicia el juego despierta, para que se duerma deben pasar 3 minutos consecutivos sin que se activen los sensores de sonido o luz y sin comer o jugar.

- Una vez dormido, la mascota recuperará un nivel de energía por cada hora en tiempo de juego que duerma de manera consecutiva. 

- Su nivel de energía no disminuirá mientras duerma.

- Estar dormido no afecta la velocidad a la que sus niveles de hambre o felicidad disminuyen.

La mascota se despertará al cumplir al menos una de las siguientes condiciones:

- El sensor de sonido es activado durante más de 10 segundos de tiempo de juego consecutivos.

- El sensor de luz es activado durante más de 10 segundos de tiempo de juego consecutivos.

- Se presiona el botón de alimentar.

- Se presiona el botón de juego.

## Estados y Pantalla

La pantalla utilizada es monocrómatica de resolución 48x84 píxeles, por lo que se considera espacio suficiente para mostrar todos los posibles estados en la pantalla.

Para añadir dinamismo, los medidores parpadean constantemente.

Nótese la agrupación de los sprites en grupos de 8 filas, hecho así entendiendo el sistema de transmisión SPI que utiliza la pantalla en el cual cada byte de información corresponde a una columna de 8 píxeles, así se simplifica la tarea del dibujado en la futura implementación.

La mascota cuenta con estados y medidores que indican su estado actual y sus necesidades más inmediatas.

Los elementos en la pantalla se distribuirán de la siguiente manera:

![image](https://github.com/user-attachments/assets/2b92ca5f-6cff-45aa-a48e-6803e82b4f9d)

TEST en la parte superior indica si se encuentra en una partida o en modo TEST.

x24 en la parte inferior muestra una de las posibles velocidades de juego.

Cuando alguno de los medidores de energía, hambre o felicidad se encuentre en 1 se mostrará un estado distinto de la mascota que muestra su necesidad más inmediata, así:

### Hambriento:

![image](https://github.com/user-attachments/assets/c8a602d3-441e-4bd3-b28b-a8b2708daaf5)

### Somnoliento:

![image](https://github.com/user-attachments/assets/e6b267e9-f2a0-4810-9e7e-61ce8d5bf39e)

### Aburrido (se esconde en su Pokebola):

![image](https://github.com/user-attachments/assets/1da3a721-bac2-4226-b8a3-716ad0921c7b)

### Muerto (al dejar disminuir a 0 cualquiera de los medidores):

![image](https://github.com/user-attachments/assets/87b46f56-cb9d-4e60-b941-cc3f3c336425)

Los indicadores de luz y sonido se activarán únicamente cuando exista 1 lógico en su respectivo sensor, de lo contrario no serán dibujados.

Al realizar alguna acción se mostrará una animación distinta que la represente, así:

### Dormir:

![image](https://github.com/user-attachments/assets/884e8995-121d-4344-b52b-04f9f1506052)

En el que las "z" parpadean

### Alimentar:

Una manzana se desplaza a lo largo de la pantalla hasta la mascota

![image](https://github.com/user-attachments/assets/069cdc79-67de-40e5-8820-c3d7554a753b)

### Jugar:

Un entrenador camina hacia la mascota y baila con ella unos momentos

![image](https://github.com/user-attachments/assets/4761e8b7-aebb-45f0-90a2-6ed95feac6fb)

Cuando la mascota no se encuentra reaizando ninguna actividad ni tiene ninguna necesidad inmediata, se quedará quieta moviendo la cola

### Inactiva:

![image](https://github.com/user-attachments/assets/120bfba0-9d98-4145-b4b7-b72424e44615)

## Arquitectura
### Comunicación SPI

La comunicación con la pantalla se da mediante el protocolo spi, con la ventaja añadida de no contar con la existencia de MOSI (Master Output Slave Input), puesto que la pantalla es, en todo momento, un elemento pasivo.

Las variables encargadas de modular la pantalla son las siguientes:

Reset: Activa en 1, regresa la pantalla a su estado inicial, borrando en su totalidad la pantalla y requiriendo una nueva inicialización de parámetros de dibujado (entre los especificados por el fabricante)

Chip Enable:  Activa en 0, permite el ingreso de datos a la pantalla, ya sean parámetros de dibujado o datos a dibujar.

DC: Activa en 1 para dibujar datos en la pantalla, en 0 permite el cambio de los parámetros de dibujado, tales como posición horizontal y vertical para dibujar, activar o desactivar modo inverso de coloreado y cambiar la orientación de dibujado.

Serial Data In: Datos acumulados en bytes, pueden ser comandos o datos a dibujar.

Serial Clock: Reloj que rige todos los procesos de la pantalla. 

La pantalla requiere un pulso de RES inmediatamente después de inicializar, junto a un set específico de comandos inmediatamente después para que se ejecute la pantalla en modo “normal”, es decir, con dibujado horizontal y modo normal de coloreado, estos son especificados por el fabricante:

![Screenshot from 2024-08-21 20-41-57](https://github.com/user-attachments/assets/8c1132ff-ee28-411c-85b9-6244307632c2)

La lectura de datos se ejecuta de acuerdo al siguiente gráfico especificado por el fabricante 

En este se puede apreciar como toda la lógica se rige con lectura en el surco positivo del reloj de la pantalla, por ello mismo es necesario decidir una de varias posibilidades: realizar la lectura de datos para enviar a la pantala en el flanco negativo, hacer los cambios en el mismo surco positivo teniendo en cuenta el retraso de un ciclo de reloj o realizar los posibles cambios con un reloja de mayor frecuencia durante alguno de los surcos, no en los flancos.

Por simplicidad se decidió en la segunda, para mantener consistencia en la lectura de datos, permanentemente en el flanco positivo.

![Screenshot from 2024-08-21 19-25-51](https://github.com/user-attachments/assets/80fdaa8e-ffda-4477-b110-a80c9fba5295)

![image](https://github.com/user-attachments/assets/877a0157-4958-40d7-9703-71621a55d97e)

Se puede notar que el cambio de mosi se ejecuta al flanco positivo de sclk, que corresponde al reloj que rige a la pantalla.

### Dibujado

Teniendo un protocolo establecido para comunicarse con la pantalla, es necesario establecer un sistema de dibujado que permita dibujar secciones en la pantalla una y otra vez, por ello se decidió un módulo intermedio a los módulos de control de pantalla y de control de estados del personaje.

En este módulo se identifican las siguientes necesidades:

- Los cambios ejecutados en el módulo del personaje deben ser enviados tan pronto como sea posible a la pantalla
- Los indicadores de luz y sonido deben "entrar" de manera directa a este módulo a fin de que los respectivos dibujos se dibujen de inmediato. 
- Debe coordinar acciones "lentas" con acciones "rápidas", es decir, coordinar la velocidad de parpadeo de la pantalla y las animaciones de manera independiente al reloj de la FPGA y al reloj de la pantalla.
- NO debe tener lógica de juego.

Originalmente se concibió la máquina de estados para el dibujado como una colección de más de 27 estados, uno por cada dibujo posible más uno de inicialización y uno de "IDLE"; sin embargo esta forma de organizar los sprites probó ser terriblemente ineficiente, aunque sencilla y funcional, pero debío ser descartada para favorecer un menor consumo de los limitados elementos combinacionales en la FPGA.

La máquina de estados se redujo a 3 posibles: "INIT" estado de inicialización, "PENCIL" estado de dibujado y "IDLE" estado en el que se analizan los elementos en pantalla para dibujar o no el siguiente elemento; con este método, los elementos combinacionales son mucho menores, pero es necesario tener banco de registros que aloje todos los posibles dibujos a realizar.


En Verilog los estados son tres casos que se ejecutan a frecuencia del reloj nativo de la FPGA, usando como sincronizador la señal de avail del módulo de comunicación con la pantalla, INIT cuenta con los pasos requeridos por la pantalla para inicializarla correctamente e inmediatamente procede a decidir que los 

## Diagramas

![image](https://github.com/user-attachments/assets/760c7564-6907-47f7-a4dc-71ff579cf3e7)

Por simplicidad se apartan los modulos de control de la pantalla y las imágenes a ser mostradas en la misma, los gráficos, contenidos en el módulo sprites, contienen los pasos para dibujar cada uno de los gráficos, y envía la información al módulo de control spi, manteniendo dibujando a la pantalla constantemente.

Dado que se pretende dibujar constantemente y existen animaciones es necesario generar distintos relojes de distintas frecuencias a fin de coordinar todas las posibles velocidades de juego.

El módulo statemaster es el regulador de los posibles estados y valores pertinentes para el juego, dependiendo de esta información (enviada al módulo sprites) se deciden que gráficos se dibujan.![Screenshot from 2024-08-21 19-25-51](https://github.com/user-attachments/assets/6094a395-d408-4780-ad42-6d4042fd5766)







