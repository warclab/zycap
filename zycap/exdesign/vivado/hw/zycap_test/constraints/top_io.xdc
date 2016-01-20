#LEDs
#LEDs
set_property PACKAGE_PIN T22 [get_ports {leds[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[0]}]
#NET leds0           LOC = T22  | IOSTANDARD=LVCMOS33;  # "leds0"
#NET leds0           LOC = T22  | IOSTANDARD=LVCMOS33;  # "leds0"
set_property PACKAGE_PIN T21 [get_ports {leds[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[1]}]
#NET leds1           LOC = T21  | IOSTANDARD=LVCMOS33;  # "leds1"
#NET leds1           LOC = T21  | IOSTANDARD=LVCMOS33;  # "leds1"
set_property PACKAGE_PIN U22 [get_ports {leds[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[2]}]
#NET leds2           LOC = U22  | IOSTANDARD=LVCMOS33;  # "leds2"
#NET leds2           LOC = U22  | IOSTANDARD=LVCMOS33;  # "leds2"
set_property PACKAGE_PIN U21 [get_ports {leds[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[3]}]
#NET leds3           LOC = U21  | IOSTANDARD=LVCMOS33;  # "leds3"
#NET leds3           LOC = U21  | IOSTANDARD=LVCMOS33;  # "leds3"
set_property PACKAGE_PIN V22 [get_ports {leds[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[4]}]
#NET leds4           LOC = V22  | IOSTANDARD=LVCMOS33;  # "leds4"
#NET leds4           LOC = V22  | IOSTANDARD=LVCMOS33;  # "leds4"
set_property PACKAGE_PIN W22 [get_ports {leds[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[5]}]
#NET leds5           LOC = W22  | IOSTANDARD=LVCMOS33;  # "leds5"
#NET leds5           LOC = W22  | IOSTANDARD=LVCMOS33;  # "leds5"
set_property PACKAGE_PIN U19 [get_ports {leds[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[6]}]
#NET leds6           LOC = U19  | IOSTANDARD=LVCMOS33;  # "leds6"
#NET leds6           LOC = U19  | IOSTANDARD=LVCMOS33;  # "leds6"
set_property PACKAGE_PIN U14 [get_ports {leds[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[7]}]
#NET leds7           LOC = U14  | IOSTANDARD=LVCMOS33;  # "leds7"
#NET leds7           LOC = U14  | IOSTANDARD=LVCMOS33;  # "leds7"


# GPIO pin to reset the USB OTG PHY

# USB-Reset
set_property PACKAGE_PIN G17 [get_ports {gpio_0_tri_io[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_0_tri_io[0]}]
#NET "PS_GPIO[0]" LOC = G17;
#NET "PS_GPIO[0]" IOSTANDARD = LVCMOS33;

# On-board OLED
# OLED-VBAT
set_property PACKAGE_PIN U11 [get_ports {gpio_0_tri_io[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_0_tri_io[1]}]
#NET "PS_GPIO[1]" LOC = U11;
#NET "PS_GPIO[1]" IOSTANDARD = LVCMOS33;

# OLED-VDD
set_property PACKAGE_PIN U12 [get_ports {gpio_0_tri_io[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_0_tri_io[2]}]
#NET "PS_GPIO[2]" LOC = U12;
#NET "PS_GPIO[2]" IOSTANDARD = LVCMOS33;

# OLED-RES
set_property PACKAGE_PIN U9 [get_ports {gpio_0_tri_io[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_0_tri_io[3]}]
#NET "PS_GPIO[3]" LOC = U9;
#NET "PS_GPIO[3]" IOSTANDARD = LVCMOS33;

# OLED-DC
set_property PACKAGE_PIN U10 [get_ports {gpio_0_tri_io[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_0_tri_io[4]}]
#NET "PS_GPIO[4]" LOC = U10;
#NET "PS_GPIO[4]" IOSTANDARD = LVCMOS33;

# OLED-SCLK
set_property PACKAGE_PIN AB12 [get_ports {gpio_0_tri_io[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_0_tri_io[5]}]
#NET "PS_GPIO[5]" LOC = AB12;
#NET "PS_GPIO[5]" IOSTANDARD = LVCMOS33;

# OLED-SDIN
set_property PACKAGE_PIN AA12 [get_ports {gpio_0_tri_io[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_0_tri_io[6]}]
#NET "PS_GPIO[6]" LOC = AA12;
#NET "PS_GPIO[6]" IOSTANDARD = LVCMOS33;
