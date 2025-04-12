

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_redundancia is
--  Port ( );
end tb_redundancia;

architecture Behavior of tb_redundancia is

    component redundancia
        Generic ( SIMULATION_MODE : boolean := false );
        Port (
            CLK100MHZ : in STD_LOGIC;
            RESET : in STD_LOGIC;
            SW : in STD_LOGIC_VECTOR (0 downto 0);
            LED : out STD_LOGIC_VECTOR (7 downto 0);
            LED_CONTADOR_1 : out STD_LOGIC;
            LED_CONTADOR_2 : out STD_LOGIC;
            AN : out STD_LOGIC_VECTOR (7 downto 0);
            SEG : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

    signal CLK100MHZ     : STD_LOGIC := '0';
    signal RESET         : STD_LOGIC := '1';
    signal SW            : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal LED           : STD_LOGIC_VECTOR (7 downto 0);
    signal LED_CONTADOR_1 : STD_LOGIC;
    signal LED_CONTADOR_2 : STD_LOGIC;
    signal AN            : STD_LOGIC_VECTOR (7 downto 0);
    signal SEG           : STD_LOGIC_VECTOR (6 downto 0);

    constant clk_period : time := 10 ns;  -- 100 MHz clock

begin

    uut: redundancia
        generic map ( SIMULATION_MODE => true ) 
        port map (
            CLK100MHZ => CLK100MHZ,
            RESET => RESET,
            SW => SW,
            LED => LED,
            LED_CONTADOR_1 => LED_CONTADOR_1,
            LED_CONTADOR_2 => LED_CONTADOR_2,
            AN => AN,
            SEG => SEG
        );

    process
    begin
        while true loop
            CLK100MHZ <= '0';
            wait for clk_period/2;
            CLK100MHZ <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    
    process
    begin
        RESET <= '0'; 
        wait for 100 ns;
        RESET <= '1'; 
        
        
        wait for 500 ns;
        SW <= "1";

        wait for 1 us;

        -- Cambia de nuevo a contador1
        SW <= "0";
        
        wait for 500 ns;
        SW <= "1";

        wait for 1 us;

        SW <= "0";

        wait;
    end process;

end Behavior;
