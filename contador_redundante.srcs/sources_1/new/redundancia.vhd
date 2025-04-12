library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity redundancia is
    Generic ( SIMULATION_MODE : boolean := false );
    Port ( CLK100MHZ : in STD_LOGIC;
           RESET : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (0 downto 0);
           LED : out STD_LOGIC_VECTOR (7 downto 0);
           LED_CONTADOR_1 : out STD_LOGIC;
           LED_CONTADOR_2 : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           SEG : out STD_LOGIC_VECTOR (6 downto 0));           
end redundancia;

architecture Behavioral of redundancia is
    signal count1, count2 : STD_LOGIC_VECTOR (7 downto 0);
    signal clk_1hz : STD_LOGIC;
    signal reset_n : STD_LOGIC;
    signal count_value : STD_LOGIC_VECTOR (7 downto 0);

    component clk_divider
        Generic ( SIMULATION_MODE : boolean := false );
        Port ( clk_in : in STD_LOGIC;
               reset : in STD_LOGIC;
               clk_out : out STD_LOGIC);
    end component;

    component contador1
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               count : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    component contador2
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               count : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    component display_controller
        Port ( 
               clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               count : in STD_LOGIC_VECTOR (7 downto 0);
               an : out STD_LOGIC_VECTOR (7 downto 0);
               seg : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;    
begin
    -- Reset invertido (activo en bajo)
    reset_n <= not RESET;

    -- Divisor de reloj
    DIV: clk_divider 
        generic map (SIMULATION_MODE => SIMULATION_MODE)
        port map (
            clk_in => CLK100MHZ,
            reset => reset_n,
            clk_out => clk_1hz
        );

    -- Instancias de contadores sin enable
    U1: contador1 port map (clk => clk_1hz, reset => reset_n, count => count1);
    U2: contador2 port map (clk => clk_1hz, reset => reset_n, count => count2);

    -- Proceso para selecciÃ³n de salida y LEDs
    process(SW, count1, count2)
    begin
        if SW = "1" then
            count_value <= count2;
            LED_CONTADOR_1 <= '0';
            LED_CONTADOR_2 <= '1';
        else
            count_value <= count1;
            LED_CONTADOR_1 <= '1';
            LED_CONTADOR_2 <= '0';
        end if;
    end process;

    -- Salida de los LEDs generales
    LED <= count_value;

    -- Controlador del display
    DISP: display_controller port map (
        clk => CLK100MHZ,
        reset => reset_n,
        count => count_value,
        an => AN,
        seg => SEG
    );

end Behavioral;