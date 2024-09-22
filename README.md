# Entrega 1 Proyecto Tamagotchi
## Integrantes 
* Daniel Esteban Hostos
## Características Generales

El dispositivo cuenta con los siguientes botones para la interacción del usuario:

- Reset
- Alimentar
- Jugar
- Test


Y los siguientes sensores de entorno para interactuar con el mundo real:

- Sensor digital de sonido KY-037

<p align="center">
  
<img src="https://github.com/user-attachments/assets/9c4fbb6a-abda-4235-be87-2685cf2ae8f3" width="250" height="250">
  
</p>

- Sensor digital de luz LM393
  
<p align="center">
  
<img src="https://github.com/user-attachments/assets/887f02c0-d403-42a8-85f1-0686fdd790e3" width="250" height="250">
  
</p>



Para mostrar la información se usará una pantalla monocromática Nokia 5110 de 84x48 pixeles

<p align="center">
  
<img src="https://github.com/user-attachments/assets/d969fd96-ef69-4490-abf3-62f4e16ec10e" width="250" height="250">
  
</p>


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

<p align="center">
  
<img src="https://github.com/user-attachments/assets/cc99d2d2-509f-4d1a-ab49-8d831416cbc8">
  
</p>

TEST en la parte superior indica si se encuentra en una partida o en modo TEST.

x2 en la parte inferior muestra una de las posibles velocidades de juego.

La bombilla y el parlante representan la activación de los sensores de luz y sonido, respectivamente.

Cuando alguno de los medidores de energía, hambre o felicidad se encuentre en 1 se mostrará un globo de diálogo distinto de la mascota que muestra su necesidad más inmediata, así:

### Hambriento:

<p align="center">
  
<img src="https://github.com/user-attachments/assets/66b722b2-06bc-4a45-9ec4-d346d6de176d">
  
</p>

### Somnoliento:

<p align="center">
  
<img src="https://github.com/user-attachments/assets/96073884-245f-4bdd-b2fc-082f08172ba5">
  
</p>

### Aburrido:


<p align="center">
  
<img src="https://github.com/user-attachments/assets/924c19a7-77fe-46f6-b402-c9714f7eb1fe">
  
</p>

### Muerto (al dejar disminuir a 0 cualquiera de los medidores):

<p align="center">
  
<img src="https://github.com/user-attachments/assets/87b46f56-cb9d-4e60-b941-cc3f3c336425">
  
</p>

Los indicadores de luz y sonido se activarán únicamente cuando exista 1 lógico en su respectivo sensor, de lo contrario no serán dibujados.

Al realizar alguna acción se mostrará una animación distinta que la represente, así:

### Dormir:

<p align="center">
  
<img src="https://github.com/user-attachments/assets/70d5c992-3ae9-460e-8e0f-f267693ca930">
  
</p>

En el que las "z" parpadean

### Alimentar:

Una manzana se desplaza a lo largo de la pantalla hasta la mascota


<p align="center">
  
<img src="https://github.com/user-attachments/assets/069cdc79-67de-40e5-8820-c3d7554a753b">
  
</p>


### Jugar:

Un entrenador camina hacia la mascota y baila con ella unos momentos

<p align="center">
  
<img src="https://github.com/user-attachments/assets/6301b62a-bc04-45b4-b435-d3c639088781">
  
</p>


Cuando la mascota no se encuentra reaizando ninguna actividad ni tiene ninguna necesidad inmediata, se quedará quieta moviendo la cola

### Inactiva:

<p align="center">
  
<img src="https://github.com/user-attachments/assets/120bfba0-9d98-4145-b4b7-b72424e44615">
  
</p>

## Caja Negra

<p align="center">
  
<img src="https://github.com/user-attachments/assets/3f140011-a0de-47d9-8534-e61a5d957600">
  
</p>

El desarrollo de cada uno de los módulos que componen el proyecto fue realizado por separado, arriba se muestran entonces cada una de las cajas negras correspondientes, además de la caja negra general que encapsula el proyecto en su totalidad.

## Relojes

Es necesaria la creación de dos relojes independientes, además del existente por defecto en la FPGA, estos son el reloj de tiempo natural y otro de frecuencia variable, que corresponde al que rige el tiempo de juego, este último puede ser idéntico al reloj natural o tener un período fracción del reloj natural, desde 1/2 hasta 1/16.

Para lograr esto de manera eficiente deben construirse los posibles relojes en base al de menor período, en este caso el de 1/16 de segundo y teniendo en cuenta que el reloj base tiene una frecuencia de 50MHz.

<p align="center">
  
<img src="https://github.com/user-attachments/assets/022d0b87-11f3-4ffc-8d5e-4b98e5ef8c99">
  
</p>

Mdivisor es el input del cual depende la aceleración, a mayor número, mayor período de reloj; es enteramente dependiente del usuario.

"divisor" es el valor del mínimo divisor posible y corresponde al número 781.250, pues la duración de un semiciclo es de 25.000.000 ciclos de reloj de la FPGA; dado que 25.000.000/781.250 = 32 , es necesario recorrer 32 veces el ciclo para completar un semiciclo de reloj y ejecutar el flanco.

## Registros de Juego

Los registros asociados al juego son, además de los 4 básicos representados por las figuras en la pantalla (salud, hambre, felicidad y energía) todos los relojes asociados a la disminución y aumento de estas acciones, pues cada una de ellas, excepto salud, disminuye a ritmo de un reloj asociado, el cual se reinicia automáticamente cuando dismiye el valor.

Así mismo, el reloj asociado al sueño funciona de manera dual para contabilizar el tiempo requerido para quedarse dormido y el tiempo que lleva dormido para determinar si debe o no recuperar energía.

Play y feed tienen relojes asociados para determinar si el juego permite realizar la acción, de acuerdo a las condiciones especificadas anteriormente.

El registro de salud se rige por una condición simple: inicia en 3 y disminuye en 1 por cada uno de los demás registros que tenga valor 1.

## Pulsado de Botones

### Button_press

Los botones test y reset tienen la particularidad de funcionar únicamente una vez se ha mantenido pulsado durante 5 segundos, mediante la siguiente lógica.

![sprites drawio(6)](https://github.com/user-attachments/assets/27ff64dc-8402-4033-b230-41c7b5dd00cb)

Suponiendo que la "lectura" de los pasos se de una vez por siclo de reloj button_pressed permanece activo por tan solo un ciclo, pues se desactiva inmediatamente, sin embargo, el ciclo de reloj es de periodo 1 segundo. Ya que la lectura de los datos de button_press para ambos botones se realiza mediante el reloj de 50MHz no hay problema para realizar la lectura.

### Antirebote

El botón reset, cuando se pulsa brevemente, tiene la función de aumentar el valor de aceleración, para permitir que aumente en un solo valor por pulsación se limitó la alteración del registro correspondiente a un cambio por segundo, así si se mantiene pulsado el botón, cambiará paulatinamente despúes del primer aumento, que es inmediato. 


```
always @(posedge clock) begin
	pusher<=pusher+1;
	if (pusher==150000000) begin
		allow_press<=1;
		pusher<=0;
	end
```

## Display de tiempo

Los display de 7 segmentos se usan para mostrar el tiempo de juego, por tanto responden al timer de tiempo variable, el módulo de BCDtoSSeg es el mismo usado en previos laboratorios, por tanto se obvia su explicación, sin embargo el módulo de display si se vió alterado, para lograr optimizar la lectura simultánea de horas minutos y segundos sin requerir en exceso los elementos combinacionales, pues en un primer intento el límite de estos se alcanzó tan solo en este módulo.

```
always @(posedge enable) begin
	if(rst==0) begin
		count<= 0;
		an<=6'b11111; 
	end else begin
		count<= count+1;
		an<=6'b111111; 
		case (count) 	
			3'h0: begin bcd <= num[5:0] % 10;   an<=6'b111110; end 
			3'h1: begin bcd <= (((num[5:0] - (num[5:0] % 10)) / 10) % 10);   an<=6'b111101; end 
			3'h2: begin bcd <= num[11:6] % 10;  an<=6'b111011; end 
			3'h3: begin bcd <= (((num[11:6] - (num[11:6] % 10)) / 10) % 10); an<=6'b110111; end 
			3'h4: begin bcd <= num[17:12] % 10; an<=6'b101111; end
			3'h5: begin bcd <= (((num[17:12] - (num[17:12] % 10)) / 10)%10); an<=6'b011111; end
		endcase
	end
end

```

La operación para mostrar números de dos dígitos en grupos de dos bits se mantiene de la misma forma que el laboratorio previo, con la diferencia de que este lo extendía para números de 6 dígitos, lo que la hacía terriblemente ineficiente, aquí, "num" es la concatenación de los registros de horas, minutos y segundos, es decir, un número de 18 bits.

## Comunicación SPI

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

![image](https://github.com/user-attachments/assets/877a0157-4958-40d7-9703-71621a55d97e)

Se puede notar que el cambio de mosi se ejecuta al flanco positivo de sclk, que corresponde al reloj que rige a la pantalla.


## Dibujado

Teniendo un protocolo establecido para comunicarse con la pantalla, es necesario establecer un sistema de dibujado que permita dibujar secciones en la pantalla una y otra vez, por ello se decidió un módulo intermedio a los módulos de control de pantalla y de control de estados del personaje.

En este módulo se identifican las siguientes necesidades:

- Los cambios ejecutados en el módulo del personaje deben ser enviados tan pronto como sea posible a la pantalla
- Los indicadores de luz y sonido deben "entrar" de manera directa a este módulo a fin de que los respectivos dibujos se dibujen de inmediato. 
- Debe coordinar acciones "lentas" con acciones "rápidas", es decir, coordinar la velocidad de parpadeo de la pantalla y las animaciones de manera independiente al reloj de la FPGA y al reloj de la pantalla, para simplicidad del lenguaje en esta sección se usará el término "reloj" para referirse a un reloj de tiempo natural, con un período de 1 segundo.
- NO debe tener lógica de juego.

Originalmente se concibió la máquina de estados para el dibujado como una colección de más de 27 estados, uno por cada dibujo posible más uno de inicialización y uno de "IDLE"; sin embargo esta forma de organizar los sprites probó ser terriblemente ineficiente, aunque sencilla y funcional, pero debío ser descartada para favorecer un menor consumo de los limitados elementos combinacionales en la FPGA.

La máquina de estados se redujo a 3 posibles: "INIT" estado de inicialización, "PENCIL" estado de dibujado y "IDLE" estado en el que se analizan los elementos en pantalla para dibujar o no el siguiente elemento; con este método, los elementos combinacionales son mucho menores, pero es necesario tener banco de registros que aloje todos los posibles dibujos a realizar, este se denomina "sprites".

![image](https://github.com/user-attachments/assets/376c2f32-b321-48f1-ad7d-706f498c8c11)


### INIT 

El estado init de la pantalla se ejecuta únicamente al inicializar o al reiniciar, comprende los pasos requeridos para la inicialización de la pantalla de acuerdo a las instrucciones dadas por el fabricante, además de estos, se dibuja la pantalla completamente de blanco para evitar residuos de dibujos realizados antes del encendido o el reinicio.

![image](https://github.com/user-attachments/assets/9742d9d5-837f-400d-88be-da73de508224)


```
  INIT:begin //configuracion 
    case(count)
			4'h0:begin  spistart<=1;	comm<=0; 
			if (avail) count<=4'h1;
			end
			
			4'h1: begin message<=8'b00100001;
			if (avail) count<=4'h2;
			end
			
			4'h2:begin  message<=8'b10010000;	 
			if (avail) count<=4'h3;
			end
			
			4'h3: begin message<=8'b00100000; 
			if(avail) count<=4'h4;
			end
			
			4'h4: begin	message<=8'b00001100; 
			if(avail) count<=4'h5;
			end
			
			4'h5: begin	 comm<=1; message<=8'h0;
			if(avail) begin 
				if (i<=503) begin 
					i<=i+1;
					count<=4'h5;
					end 
				else 
				begin 
				state<=IDLE;
				count<=4'h0;
				i<=0;
          end
        end
      end
    endcase
  end
```


### IDLE 

Al finalizar la inicialización y despues de cada dibujo realizado la máquina regresa automáticamente al estado IDLE, en este, se mantiene un proceso estándar para el orden de aparición de las figuras, además de considerar los registros de juego recibidos por el módulo para considerar que debe dibujarse u omitirse, una vez se establece que es lo próximo en ser dibujado se alteran los registros "first_step", "last_step", "y_pos" y "x_pos" requeridos para la figura.

![image](https://github.com/user-attachments/assets/8f072470-e7cd-4b5e-9988-309344e44ae5)

Nótese que este proceso no cuenta con entradas de reset, esto se debe a que es irrelevante en que zona se inicie a dibujar; las condiciones explicadas para el dibujado o borrado de cada una de las zonas es considerada en el estado.


### PENCIL

El estado pencil debe ser inicializado con los registros "x_pos", "y_pos", "first_step" y "last_step", los dos primeros indican la posición horizontal y fila para el dibujado, mientras los dos últimos indican la sección del registro "sprites" que se va a dibujar, y se transmiten a la pantalla por medio del registro "message", por otro lado, los registros "spistart" y "comm" siguen siempre el mismo proceso durante los pasos contenidos en el módulo.

Los pasos iniciales del módulo consisten en fijar las coordenadas de posición de la figura, luego se dibuja cada uno de las columnas de 8 bits que corresponden al paso actual, aumentanto en 1 el paso al ser transmitido el mensaje, se finaliza el dibujado cuando el paso enviado es el último paso requerido para la figura.

```
  PENCIL: begin //dibujar
    case(count)
			4'h0: begin spistart<=1; comm<=0; message<=pencil_pos+128;// Coordinates X
			if(avail) count<=4'h1;
			end
			
			4'h1: begin message <=y_pos +64; // en y 
			if(avail) count<=4'h2;
			end
			
			4'h2: begin message<=y_pos +64;step<=first_step; // en y 
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; 
			message<=sprites[step];//dibujo 
			if(avail)begin
				step<=step+1;
				if (step==last_step) begin
					spistart=0;
					state<=IDLE;
					count<=0;
				end 
			end		
			end
			endcase
		end
```

## Figuras

### Parpadeo

El parpadeo, al igual que las animaciones, se rije por el reloj de tiempo natural, se decidió que todos los elementos repetidos parpadasen basandose en un tamagotchi real, con una pantalla similar, que tenía esta característica presuntamente para ahorrar energía, pues la mitad del tiempo no había nada dibujado en la pantalla.

Dado que la pantalla tiene memoria, y mantiene los objetos dibujados en pantalla a menos de que se le indique lo contrario, es necesario indicarle a cada ciclo si debe dibujar los elementos o "borrarlos", siendo necesario aclarar que el término "borrar" no se refiere a enviar el comando borrar a la pantalla siguiendo las instrucciones dadas por el fabricante, pues esto lo que hace es hacer 0 todos los bits en pantalla, en este caso, y durante el resto del documento, borrar significa "dibujar" en blanco secciones específicas de la pantalla; para corazones, caras y huesos borrar significa dibujar un sprite de exactamente el mismo tamaño, pero todo en blanco, en cambio para los niveles de la batería, significa dibujar únicamente los bordes de la batería, pero blanco el interior.

Se sigue este proceso en lugar de borrar toda la pantalla porque no todos los elementos en pantalla deben ser borrados, el único elemento que no tiene una animación asociada y que se mantiene al borrar los elementos parpadeantes es la batería (aunque los niveles en su interior sí parpadean).

### Dibujado de elementos repetidos (corazones, huesos,etc)

Los elementos repetidos son aquellos que indican los niveles de la mascota y se dibujan más de una vez; tienen todos 8 pixels de alto tal y como se puede apreciar en la distribución de elementos en pantalla. A fín hacer este dibujado con un solo sprite, a la hora de dibujar, el módulo sigue el siguiente proceso:

![image](https://github.com/user-attachments/assets/77706040-0ecb-420c-81bc-a2f2b18ee70e)


### Dibujado de elementos únicos 

Se denominan elementos únicos a los que aparecen en pantalla únicamente una vez, lo son: la mascota, la batería, el entrenador, la manzana, los globos de dialogo y los indicadores de test, acelerador, luz y sonido.

El dibujado de estos se divide en dos tipos, sprites grandes y pequeños, dependiendo del alto del elemento; la mascota, el entrenador y los globos de diálogo tienen 16 pixels de alto, los demás tan solo 8. En realidad no existe diferencia para dibujar elementos grandes y pequeños, pues un elemento grande es en realidad dos elementos pequeños dibujados coordinadamente, pero debe dibujarse la segunda inmediatamente después de la primera para evitar disonancia, además de que todos los elemenos grandes tienen algún tipo de animación asociada. 

### Dibujado de indicadores de luz y sonido

#### Sonido

El sensor de sonido funciona de una forma particular, pues en la práctica este no entrega un 1 digital aunque haya un sonido sostenido, en cambio, fluctura en lapsos cortos, a causa de esto, el indicador de sonido en pantalla parpadea de manera indeseada si simplemente se configura un wire del sensor al indicador en pantalla.

Para que el indicador en pantalla se encienda únicamente cuando hay sonido, pero se mantenga encendido por lapsos sostenidos se configuró de la siguiente forma: cuando se haya encendido, tiene que pasar al menos un segundo completo antes de que pueda desaparecer, si el sonido dura varios segundos, el indicador desaparecerá un segundo después de que el sonido haya cesado.

#### Luz

El sensor de luz no sufre este problema y por tanto su implementación tan solo requiere un condicional en el ciclo de IDLE,

### Animaciones

Las animaciones son cambios en los sprites cuando se ejecutan eventos asociados al reloj de 1 segundo, tienen animaciones la mascota, el entrenador, la manzana y los globos de diálogo.

La mascota tiene animaciones permanenetemente en dos de sus estados, dormido y despierto. Cuando está despierto su animación asemeja un jadeo y depende únicamente en que surco del reloj se encuentre en un determinado momento, mientras que cuando está dormido se rije de una manera diferente a fin de coordinar la velocidad a la que aparecen las "z" que indican que está dormido.

Las 3 "z" son un solo sprite de 13 pixels de ancho y 8 de alto, para simular su aparición se asocia un registro de 2 bits que aumenta su valor permanentemente a son del flanco positivo del reloj e indica cuantas se dibujarán: 1,2,3 o ninguna. De esta manera, el módulo dibuja siempre 13 bits de ancho, pero el registro asociado indica cuantos de estas columnas son parte del sprite y cuantas son borradas. 

Las animaciones asociadas al entrenados y a la manzana funcionan de manera similar con la única diferencia siendo el tipo de dibujado, ya que el entrenador es un sprite grande. Estas animaciones hacen uso de un comparador entre el reloj nativo y el natural para ejecutar cambios en un registro que indica la posición horizontal del elemento, esto a fin de facilitar su manipulación en el código, ya que antes de dibujarse en una posición distinta el elemento es dibujado cientos de veces en una misma posición debido a que el dibujado se hace con el reloj rápido. Al funcionar los comparadores con los cambios de estado del reloj natural, son en si mismos "relojes" con período de medio segundo con la gran diferencia de no ser permanentes (solo están activos cuando lo permiten los eventos asociados).

Para el caso de la manzana, únicamente su posición se altera a ritmo del comparador, en el caso del entrenador tanto su posición como su set de sprites se cambia, para dar la ilusión de caminar.

Los globos de diálogo siguen un comportamiento simiar a un parpadeo, sin embargo su funcionamiento es diferente, pues los globos de diálogo deben poder coexistir y aparecer durante lapsos cortos sin sobreponerse unos a otros, lo que es, en realidad, una animación. Para lograr esto, se hace uso de un registro de un solo bit, llamado "alternador" que cambia su valor únicamente en el flanco positivo del reloj natural, siendo por esto en realidad un reloj de periodo 2s; cuando este registro se encuentre en 0, aparecen 2 de los globos, uno durante el tiempo activo del reloj natural y el otro durante su tiempo inactivo, en el siguiente segundo, durante el borde activo, se muestra el globo faltante.  

### Limpieza 

El cambio de estado de mascota, entre estados de dormido, despierto o muerto, y la aparición y desaparición de globos de diálogo, hace necesario que las dos filas de bytes intermedias tengan una "limpieza" constante, al igual que las animaciones esta se ejecuta dos veces por segundo, siendo prácticamente imperceptible gracias a la velocidad de dibujado de la pantalla. 


## Modo Test

El modo Test, a diferencia del modo juego, se rige siempre por el reloj de tiempo natural, esto se hace para permitir que ejecución de animaciones ejemplificando el comportamiento de la mascota bajo diferentes condiciones, a modo de tutorial. Para lograr esto, se establece una máquina de estados que cambia de estado cuando se pulsa el boton reset. Debido al reloj usado, para el modo test existe un ligero retraso entre la pulsación y el reflejo de la acción. 

Cuando se ejecutan las acciones pertinentes a recuperar energía, alimentarse o jugar, los indicadores de estado aumentan a ritmo de 1 por segundo, reiniciando a 0 cuando se intenta superar su valor máximo.

```
if (test_mode) begin
		case (test_case) 
	1:begin
		test_pet_state <= DEAD;
		test_health <= 0;
		test_happiness <=0;
		test_hunger <= 0;
		test_energy <= 0;
	end
		
	2:begin
		test_pet_state <= STAY;
		test_hungry<=1;
		test_health <= 3;
		test_happiness <=3;
		test_hunger <= 1;
		test_energy <= 4;
	end
			
	3:begin
		test_sleepy <= 1;
		test_health <= 3;
		test_happiness <=3;
		test_hunger <= 3;
		test_hungry <=0;
		test_energy <= 1;
	end
	
	4:begin
		test_sleepy <= 0;
		test_energy <= 4;
		test_happiness <= 1;
		test_bored <= 1;
	end
	
	5:begin
		test_hungry<=1;
		test_hunger<=1;
		test_energy<=1;
		test_sleepy<=1;
	end 
	
	6:begin
		test_play<=1;
		test_bored<=0;
		test_happiness <= happiness+1;
	end 
	
	7:begin
		test_play <=0;
		test_happiness <=3;
		test_sleepy <= 0;
		test_pet_state<= ASLEEP;
		test_energy <= energy+1;
	end
	
	8:begin
		test_energy<=4;
		test_pet_state<=STAY;
		test_feed<=1;
		test_hunger<= test_hunger+1;
		test_hungry <= 0;
	end
	
	9:begin
		test_feed<=0;
		test_hunger<= 3;
		test_hungry <= 0;
		test_hunger <=2;
		test_energy <=3;
		test_health <=2;
		test_happiness <=2;
	end
	endcase
end

```








