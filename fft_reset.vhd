---------------------------------------------------------------
entity ffT_reset is
  Port ( reset : in STD_LOGIC;
         clk : in STD_LOGIC;
         ce : in STD_LOGIC;
         t : in STD_LOGIC;
         q : in STD_LOGIC);

end ffT_reset;

architecture Behavioral of ffT_reset is

signal q_int : std_logic;

begin

process (clk, reset)
begin
   if reset ='1' then
      q_int <= '0';
      elsif (clk'event and clk ='1') then
        if ce ='1' then
                if t ='1' then
                  q_int <= not q_int;
                end if;
        end if;
      end if;
end process;
q <= q_int;

end Behavioral;
---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ffD_reset is
  Port ( clk : in STD_LOGIC;
         reset : in STD_LOGIC;
         ce : in STD_LOGIC;
         d : in STD_LOGIC;
         q : in STD_LOGIC);

end ffD_reset;

architecture Behavioral of ffD_reset is
begin
process (clk, reset)
begin
   if reset ='1' then
      q <= '0';
      elsif (clk'event and clk ='1') then
        if ce ='1' then
           q <= d;
        end if;
      end if;
end process;

end Behavioral;
---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ffD_preset is
  Port ( clk : in STD_LOGIC;
         preset : in STD_LOGIC;
         ce : in STD_LOGIC;
         d : in STD_LOGIC;
         q : in STD_LOGIC);

end ffD_preset;

architecture Behavioral of ffD_preset is
begin
process (clk, preset)
begin
   if preset ='1' then
      q <= '1';
      elsif (clk'event and clk ='1') then
        if ce ='1' then
           q <= d;
        end if;
      end if;
end process;

end Behavioral;
---------------------------------------------------------------
-- contador.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

architecture Behavioral of contador is

  component ffT_reset
	port(
		reset : in std_logic;
		clk : in std_logic;
		ce : in std_logic;
		t : in std_logic;          
		q : out std_logic
		);
	end component;

	component ffD_preset
	port(
		clk : in std_logic;
		preset : in std_logic;
		ce : in std_logic;
		d : in std_logic;          
		q : out std_logic
		);
	end component;
	
	component ffD_reset
	port(
		clk : in std_logic;
		reset : in std_logic;
		ce : in std_logic;
		d : in std_logic;          
		q : out std_logic
		);
	end component;
	
	signal qa, qb, qc, qd : std_logic;
	signal ta, db, tc, dd : std_logic;

begin
  unitA: ffT_reset 
  port map (
		reset => reset,
		clk => clk,
		ce => ce,
		t => ta,
		q => qa );
	unitB: ffD_preset 
  port map(
		clk => clk,
		preset => reset,
		ce => ce,
		d => db,
		q => qb);
	unitC: ffT_reset 
  port map(
		reset => reset,
		clk => clk,
		ce => ce,
		t => tc,
		q => qc);
  unitD: ffD_reset 
  port map(
		clk => clk,
		reset => reset,
		ce => ce,
		d => dd,
		q => qd );
		
	ta <= (qa or (qc and not qd));
	db <= ((not qc and qd and qb) or (qd and not qa and not qb) or (not qc and not qa and not qb));
	tc <= (qb or qc or qd);
	dd <= ((not qd and qb) or (not qd and qa) or (qd and not qa and not qb));
	
	count <= qa & qb & qc & qd;


end Behavioral;


---------------------------------------------------------------
-- dec7seg.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dec7seg is
    Port ( bcd : in  STD_LOGIC_VECTOR (3 downto 0);
           led : out  STD_LOGIC_VECTOR (6 downto 0));
end dec7seg;

architecture Behavioral of dec7seg is
	
	signal and1_led6, and2_led6 : std_logic;
	signal and1_led5, and2_led5, and3_led5 : std_logic;
	signal and1_led4 : std_logic;
	signal and1_led3, and2_led3, and3_led3 : std_logic;
	signal and1_led1, and2_led1 : std_logic;
	signal and1_led0, and2_led0 : std_logic;

begin

	and1_led6 <= ((not(bcd(3))) and (not(bcd(2)))) and (not(bcd(1)));
	and2_led6 <= (bcd(2) and bcd(1)) and bcd(0);
	and1_led5 <= bcd(1) and bcd(0);
	and2_led5 <= ((not(bcd(3))) and (not(bcd(2)))) and bcd(0);
	and3_led5 <= ((not(bcd(3))) and (not(bcd(2)))) and bcd(1);
	and1_led4 <= (bcd(2) and not(bcd(3))) and (not(bcd(1)));
	and1_led3 <= ((not(bcd(3))) and (not(bcd(2)))) and (bcd(0) and (not(bcd(1))));
	and2_led3 <= ((bcd(2)) and (not(bcd(1)))) and (not(bcd(0)));
	and3_led3 <= (bcd(2) and bcd(1)) and bcd(0);
	and1_led1 <= (bcd(2) and not(bcd(1))) and bcd(0);
	and2_led1 <= (bcd(2) and bcd(1)) and (not(bcd(0)));
	and1_led0 <= ((not(bcd(3))) and (not(bcd(2)))) and (bcd(0) and (not(bcd(1))));
	and2_led0 <= (bcd(2) and not(bcd(1))) and (not(bcd(0)));

	led(6) <= and1_led6 or and2_led6;
	led(5) <= (and1_led5 or and2_led5) or and3_led5;
	led(4) <= bcd(0) or and1_led4;
	led(3) <= (and1_led3 or and2_led3) or and3_led3;
	led(2) <= ((not(bcd(3))) and (not(bcd(2)))) and (bcd(1) and (not(bcd(0))));
	led(1) <= and1_led1 or and2_led1;
	led(0) <= and1_led0 or and2_led0;

end Behavioral;
--------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sistema is
    Port ( clk : in  STD_LOGIC;
           ce : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           count : inout  STD_LOGIC_VECTOR (3 downto 0);
           led : out  STD_LOGIC_VECTOR (6 downto 0));
end sistema;

architecture Behavioral of sistema is
	
	COMPONENT contador
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		ce : IN std_logic;          
		count : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT dec7seg
	PORT(
		bcd : IN std_logic_vector(3 downto 0);          
		led : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;
	
	signal int : std_logic_vector(3 downto 0);

begin
	
	Inst_contador: contador PORT MAP(
		clk => clk,
		reset => reset,
		ce => ce,
		count => int );

	Inst_dec7seg: dec7seg PORT MAP(
		bcd => int,
		led => led );
		
	count <= int;
end Behavioral;

---------------------------------------------------------------------------
--tb
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY sistema_tb IS
END sistema_tb;
 
ARCHITECTURE behavior OF sistema_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sistema
    PORT(
         clk : IN  std_logic;
         ce : IN  std_logic;
         reset : IN  std_logic;
         count : INOUT  std_logic_vector(3 downto 0);
         led : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal ce : std_logic := '0';
   signal reset : std_logic := '0';

	--BiDirs
   signal count : std_logic_vector(3 downto 0);

 	--Outputs
   signal led : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sistema PORT MAP (
          clk => clk,
          ce => ce,
          reset => reset,
          count => count,
          led => led
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
	 
      reset <= '1'; ce <= '0';
      -- hold reset state for 20 ns.
      wait for 100 ns;	
		reset <= '0'; ce <= '1';
      wait for clk_period*10;
		
      wait for 150 ns;	
		reset <= '1'; ce <= '0';
      wait for 20 ns;
		reset <= '0'; ce <= '1';
      wait for clk_period*10;
		

      -- insert stimulus here
		
	
      wait;
   end process;

END;