library ieee;
use ieee.std_logic_1164.all;

entity SyncRamDualByteEnable is
   generic 
   (
      BYTE_WIDTH : natural := 8;
      ADDR_WIDTH : natural := 6;
      BYTES      : natural := 4
   );
   port 
   (
      clk        : in std_logic;
      
      addr_a     : in natural range 0 to 2**ADDR_WIDTH - 1;
      datain_a0  : in std_logic_vector((BYTE_WIDTH-1) downto 0);
      datain_a1  : in std_logic_vector((BYTE_WIDTH-1) downto 0);
      datain_a2  : in std_logic_vector((BYTE_WIDTH-1) downto 0);
      datain_a3  : in std_logic_vector((BYTE_WIDTH-1) downto 0);
      dataout_a  : out std_logic_vector((BYTES*BYTE_WIDTH-1) downto 0);
      we_a       : in std_logic := '1';
      be_a       : in  std_logic_vector (BYTES - 1 downto 0);
		            
      addr_b     : in natural range 0 to 2**ADDR_WIDTH - 1;
      datain_b0  : in std_logic_vector((BYTE_WIDTH-1) downto 0);
      datain_b1  : in std_logic_vector((BYTE_WIDTH-1) downto 0);
      datain_b2  : in std_logic_vector((BYTE_WIDTH-1) downto 0);
      datain_b3  : in std_logic_vector((BYTE_WIDTH-1) downto 0);
      dataout_b  : out std_logic_vector((BYTES*BYTE_WIDTH-1) downto 0);
      we_b       : in std_logic := '1';
      be_b       : in  std_logic_vector (BYTES - 1 downto 0)
   );
end;

architecture rtl of SyncRamDualByteEnable is

	type ram_t is array (0 to 2 ** ADDR_WIDTH - 1) of std_logic_vector(BYTE_WIDTH-1 downto 0);
	signal ram0 : ram_t := (others => (others => '0'));
	signal ram1 : ram_t := (others => (others => '0'));
	signal ram2 : ram_t := (others => (others => '0'));
	signal ram3 : ram_t := (others => (others => '0'));

begin 
        
   process(clk)
   begin
      if(rising_edge(clk)) then 
         if(we_a = '1') then
            -- edit this code if using other than four bytes per word
            if(be_a(0) = '1') then
               ram0(addr_a) <= datain_a0;
            end if;
            if be_a(1) = '1' then
               ram1(addr_a) <= datain_a1;
            end if;
            if be_a(2) = '1' then
               ram2(addr_a) <= datain_a2;
            end if;
            if be_a(3) = '1' then
               ram3(addr_a) <= datain_a3;
            end if;
         end if;
         dataout_a <= ram3(addr_a) & ram2(addr_a) & ram1(addr_a) & ram0(addr_a);
      end if;
   end process;
   
   process(clk)
   begin
      if(rising_edge(clk)) then 
         if(we_b = '1') then
               -- edit this code if using other than four bytes per word
            if(be_b(0) = '1') then
               ram0(addr_b) <= datain_b0;
            end if;
            if be_b(1) = '1' then
               ram1(addr_b) <= datain_b1;
            end if;
            if be_b(2) = '1' then
               ram2(addr_b) <= datain_b2;
            end if;
            if be_b(3) = '1' then
               ram3(addr_b) <= datain_b3;
            end if;
         end if;
         dataout_b <= ram3(addr_b) & ram2(addr_b) & ram1(addr_b) & ram0(addr_b);
      end if;
   end process;  
   
  
end rtl;