library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UT is
    port(
        clk : in std_logic;
        rst : in std_logic;
        Sample_in : in signed(7 downto 0);
        Sample_out : out signed(7 downto 0);
        Sample_clk : in std_logic;
        mux1, mux2 : in unsigned(4 downto 0);
        en_In, en_Out : in std_logic;
        en_acc : in std_logic;
        resetAcc : in std_logic
    );
end UT;

architecture behavior of UT is
    type rom_type is array (0 to 30) of signed(7 downto 0);
    constant coeffs : rom_type := (
        to_signed(0, 8), to_signed(0, 8), to_signed(0, 8), to_signed(0, 8), to_signed(0, 8), to_signed(0, 8),
        to_signed(1, 8), to_signed(1, 8), to_signed(1, 8), to_signed(-1, 8), to_signed(-3, 8), to_signed(-3, 8),
        to_signed(2, 8), to_signed(9, 8), to_signed(16, 8), to_signed(19, 8), to_signed(16, 8), to_signed(9, 8),
        to_signed(2, 8), to_signed(-3, 8), to_signed(-3, 8), to_signed(-1, 8), to_signed(1, 8), to_signed(1, 8),
        to_signed(1, 8), to_signed(0, 8), to_signed(0, 8), to_signed(0, 8), to_signed(0, 8), to_signed(0, 8),
        to_signed(0, 8)
    );
    type ram_type is array (0 to 30) of signed(7 downto 0);
    signal samples : ram_type;
    signal acc : signed(20 downto 0);
    signal reg_mult : signed(15 downto 0);


begin
    decale : process(rst, sample_clk)
    begin
        if rst = '1' then
            samples <= (others => (others => '0'));
        elsif rising_edge(sample_clk) then
            
                
                for i in 30 downto 1 loop
                    samples(i) <= samples(i-1);
                end loop;
                samples(0) <= Sample_in;
            
        end if;
    end process decale;

  mult : process(samples, mux1, mux2)
begin
    reg_mult <= resize(
        samples(to_integer(mux1)) * coeffs(to_integer(mux2)), 
        reg_mult'length
    );
end process mult;
    acc_process : process(sample_clk, rst)
    begin
        if rst = '1' then
            acc <= (others => '0');
        elsif rising_edge(sample_clk) then
            if en_acc = '1' then
                acc <= acc + resize(reg_mult, acc'length);
            end if;
        end if;
    end process acc_process;

    output_process : process(en_Out, acc)
    begin
        if en_Out = '1' then
            Sample_out <= resize(shift_right(acc, 7), 8);
        else
            Sample_out <= (others => '0');
        end if;
    end process output_process;

end behavior;