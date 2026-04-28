library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port(
        clk : in std_logic;
        rst : in std_logic;
        sample_clk : in std_logic;
        mux1, mux2 : out unsigned(4 downto 0);
        en_In, en_Out : out std_logic;
        en_acc : out std_logic;
        resetAcc : out std_logic
    );
end UC;

architecture behavior of UC is
    type state_fsm is (S0, S1, S2, S3);
    signal state : state_fsm := S0;
    signal next_state : state_fsm;
    signal cmr : unsigned(4 downto 0) := (others => '0');
    signal next_cmr : unsigned(4 downto 0);
    
begin
    mux1 <= cmr;
    mux2 <= cmr;

    seq : process(sample_clk, rst)
    begin
        if rst = '1' then
            state <= S0;
            cmr <= (others => '0');
        elsif rising_edge(sample_clk) then
            state <= next_state;
            cmr <= next_cmr;
        end if;
    end process;
    comb : process(state, cmr)
        begin
            case state is
                when S0 =>
                    next_state <= S1;
                    en_in <= '0';
                    en_Out <= '0';
                    resetAcc <= '0';
                    en_acc <= '0';
                    next_cmr <= (others => '0');
                when S1 =>
                    next_state <= S2;
                    en_in <= '1';
                    en_Out <= '0';
                    resetAcc <= '1';
                    en_acc <= '0';
                    next_cmr <= (others => '0');
                when S2 =>
                    if cmr < 30 then
                        next_state <= S2;
                        en_in <= '0';
                        en_Out <= '0';
                        resetAcc <= '0';
                        en_acc <= '1';
                        next_cmr <= cmr + 1;
                    else
                        next_state <= S3;
                        en_in <= '0';
                        en_Out <= '0';
                        resetAcc <= '0';
                        en_acc <= '0';
                    end if;
                    
                when S3 =>
                    next_state <= S0;
                    en_in <= '0';
                    en_Out <= '1';
                    resetAcc <= '0';
                    en_acc <= '0';
                when others =>
                    next_state <= S0;
                    next_cmr <= (others => '0');
                    en_in <= '0';
                    en_Out <= '0';
                    resetAcc <= '0';
                    en_acc <= '0';

        end case ;
        end process comb;
        end behavior;