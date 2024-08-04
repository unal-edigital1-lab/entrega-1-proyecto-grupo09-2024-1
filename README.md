# Entrega 1 Proyecto Tamagotchi
## Integrantes 
* Julian David Monsalve Sanchez
* Jonathan Andres Jimenez Trujillo
* Daniel Esteban Hostos
## Características Generales

El dispositivo cuenta con los siguientes botones para la interacción del ususario:

- Reset
- Alimentar
- Jugar
- Acelerar
- Test


Y los siguientes sensores de entorno para interactuar con el mundo real:

- Sensor digital de sonido
- Sensor digital de luz

Toda la información se desplegará en una pantalla monocromática de 48x84 píxeles

## Descripción General

La mascota cuenta 4 variables cuyo estado depende de las interacciones del usuario a lo largo del tiempo, al llegar cualquiera de ellas a cero, la mascota muere y debe reiniciarse el juego:

Se considera que un juego inicia cuando:

- Se ha presionado el botón Reset durante 5 segundos.
- Estando en modo Test, se presiona el botón Test durante 5 segundos.

- Salud - Medida en corazones, con un máximo de 3, representa el nivel combinado de bienestar de la mascota en base a su felicidad, energía y hambre
- Felicidad - Medida en caritas felices, con un máximo de 3, si llega a cero la mascota muere de depresión
- Energía - Medida en niveles de batería, con máximo de 4, si llega a cero la mascota muere de cansancio
- Hambre - Medida en huesos, con un máximo de 3, si llega a cero la mascota muere de inanición.

La mascota se ve afectada por dos variables del mundo real: sonido y luz

### Tiempo

Inicialmente 1 día en tiempo de juego es equivalente a un día real, sin embargo esta equivalencia puede alterarse con el botón de aceleración, al presionarlo una vez se puede variar entre 4 duraciones de un día completo en el tiempo del juego, las cuales son: 24h, 12h, 3h y 1h. 

### Felicidad, Energía y Hambre

La mascota inicia el juego con las cuatro variables en su valor máximo. Y se considera que el instante en el que se inicia el juego es el instante en el que jugó, comió y durmió por última vez.

La disminución de las variables se lleva a cabo de la siguiente manera:

- Su nivel de Felicidad disminuye a un ritmo de una carita feliz cada tres horas de tiempo de juego desde la última vez que jugó.
- Su nivel de Energía disminuye a un ritmo de un nivel cada dos horas de tiempo de juego desde la última vez que durmió.
- Su nivel de Hambre disminuye a un ritmo de un hueso cada 4 horas de tiempo de juego desde la última vez que fue alimentado. 

Como limitante de dificultad, la mascota no puede ser alimentada más de una vez por hora en tiempo de juego.

Así mismo, la mascota debe tener un plazo de descanso de al menos dos horas antes de jugar nuevamente.

Un nivel de energía es recuperado por cada hora de sueño consecutivo que logre la mascota.

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







