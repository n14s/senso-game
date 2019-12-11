library ieee; use ieee.std_logic_1164.all; 

architecture behav of timer is
begin
	run_timer: process(clk, res_n) is
		variable timer_on: std_logic;
		variable ticks: integer;
		variable level: integer;
		variable max_ticks: integer;
	begin
		if res_n = '0' then
			timer_expired <=  '0';
			timer_on:= '0';
			ticks := 0;
			level := 0;
			max_ticks := 25000000;
		else
			if clk'event and clk = '1' then
				-- reset possible timer expired signal
				timer_expired <= '0';
				
				if start_timer = '1' then
					timer_on := '1';
				end if;
				-- duration logic
				if res_duration = '1' then
					max_ticks := 25000000;
				elsif dec_duration = '1' then
					-- maxtime = maxtime - (100ms/1+x) =>>  100ms =>> 100000000ns  /  20ns  per takt/tick  =  5000000 ticks
					max_ticks := max_ticks - (5000000/(1+level));
				end if;
				-- timer/tick logic	
				if timer_on = '1' then
					ticks := ticks +1;
				else
					ticks := 0;
				end if;
				if ticks = max_ticks then
					timer_on := '0';
					timer_expired <= '1';
					level := level + 1;
				end if;
			end if;
		end if;
	end process;
end architecture;