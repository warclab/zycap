-------------------------------------------------------------------------------
-- system_zycap_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library zycap_v1_00_a;
use zycap_v1_00_a.all;

entity system_zycap_0_wrapper is
  port (
    s_axi_lite_aclk : in std_logic;
    axi_resetn : in std_logic;
    s_axi_lite_awvalid : in std_logic;
    s_axi_lite_awready : out std_logic;
    s_axi_lite_awaddr : in std_logic_vector(9 downto 0);
    s_axi_lite_wvalid : in std_logic;
    s_axi_lite_wready : out std_logic;
    s_axi_lite_wdata : in std_logic_vector(31 downto 0);
    s_axi_lite_bresp : out std_logic_vector(1 downto 0);
    s_axi_lite_bvalid : out std_logic;
    s_axi_lite_bready : in std_logic;
    s_axi_lite_arvalid : in std_logic;
    s_axi_lite_arready : out std_logic;
    s_axi_lite_araddr : in std_logic_vector(9 downto 0);
    s_axi_lite_rvalid : out std_logic;
    s_axi_lite_rready : in std_logic;
    s_axi_lite_rdata : out std_logic_vector(31 downto 0);
    s_axi_lite_rresp : out std_logic_vector(1 downto 0);
    m_axi_m2icap_aclk : in std_logic;
    m_axi_m2icap_araddr : out std_logic_vector(31 downto 0);
    m_axi_m2icap_arlen : out std_logic_vector(7 downto 0);
    m_axi_m2icap_arsize : out std_logic_vector(2 downto 0);
    m_axi_m2icap_arburst : out std_logic_vector(1 downto 0);
    m_axi_m2icap_arprot : out std_logic_vector(2 downto 0);
    m_axi_m2icap_arcache : out std_logic_vector(3 downto 0);
    m_axi_m2icap_aruser : out std_logic_vector(3 downto 0);
    m_axi_m2icap_arvalid : out std_logic;
    m_axi_m2icap_arready : in std_logic;
    m_axi_m2icap_rdata : in std_logic_vector(31 downto 0);
    m_axi_m2icap_rresp : in std_logic_vector(1 downto 0);
    m_axi_m2icap_rlast : in std_logic;
    m_axi_m2icap_rvalid : in std_logic;
    m_axi_m2icap_rready : out std_logic;
    icap_intr_out : out std_logic
  );
end system_zycap_0_wrapper;

architecture STRUCTURE of system_zycap_0_wrapper is

  component zycap is
    generic (
      C_S_AXI_LITE_ADDR_WIDTH : INTEGER;
      C_S_AXI_LITE_DATA_WIDTH : INTEGER;
      C_INSTANCE : STRING;
      C_M_AXI_M2ICAP_ADDR_WIDTH : INTEGER;
      C_M_AXI_M2ICAP_DATA_WIDTH : INTEGER
    );
    port (
      s_axi_lite_aclk : in std_logic;
      axi_resetn : in std_logic;
      s_axi_lite_awvalid : in std_logic;
      s_axi_lite_awready : out std_logic;
      s_axi_lite_awaddr : in std_logic_vector(C_S_AXI_LITE_ADDR_WIDTH-1 downto 0);
      s_axi_lite_wvalid : in std_logic;
      s_axi_lite_wready : out std_logic;
      s_axi_lite_wdata : in std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0);
      s_axi_lite_bresp : out std_logic_vector(1 downto 0);
      s_axi_lite_bvalid : out std_logic;
      s_axi_lite_bready : in std_logic;
      s_axi_lite_arvalid : in std_logic;
      s_axi_lite_arready : out std_logic;
      s_axi_lite_araddr : in std_logic_vector(C_S_AXI_LITE_ADDR_WIDTH-1 downto 0);
      s_axi_lite_rvalid : out std_logic;
      s_axi_lite_rready : in std_logic;
      s_axi_lite_rdata : out std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0);
      s_axi_lite_rresp : out std_logic_vector(1 downto 0);
      m_axi_m2icap_aclk : in std_logic;
      m_axi_m2icap_araddr : out std_logic_vector(C_M_AXI_M2ICAP_ADDR_WIDTH-1 downto 0);
      m_axi_m2icap_arlen : out std_logic_vector(7 downto 0);
      m_axi_m2icap_arsize : out std_logic_vector(2 downto 0);
      m_axi_m2icap_arburst : out std_logic_vector(1 downto 0);
      m_axi_m2icap_arprot : out std_logic_vector(2 downto 0);
      m_axi_m2icap_arcache : out std_logic_vector(3 downto 0);
      m_axi_m2icap_aruser : out std_logic_vector(3 downto 0);
      m_axi_m2icap_arvalid : out std_logic;
      m_axi_m2icap_arready : in std_logic;
      m_axi_m2icap_rdata : in std_logic_vector(C_M_AXI_M2ICAP_DATA_WIDTH-1 downto 0);
      m_axi_m2icap_rresp : in std_logic_vector(1 downto 0);
      m_axi_m2icap_rlast : in std_logic;
      m_axi_m2icap_rvalid : in std_logic;
      m_axi_m2icap_rready : out std_logic;
      icap_intr_out : out std_logic
    );
  end component;

begin

  zycap_0 : zycap
    generic map (
      C_S_AXI_LITE_ADDR_WIDTH => 10,
      C_S_AXI_LITE_DATA_WIDTH => 32,
      C_INSTANCE => "zycap_0",
      C_M_AXI_M2ICAP_ADDR_WIDTH => 32,
      C_M_AXI_M2ICAP_DATA_WIDTH => 32
    )
    port map (
      s_axi_lite_aclk => s_axi_lite_aclk,
      axi_resetn => axi_resetn,
      s_axi_lite_awvalid => s_axi_lite_awvalid,
      s_axi_lite_awready => s_axi_lite_awready,
      s_axi_lite_awaddr => s_axi_lite_awaddr,
      s_axi_lite_wvalid => s_axi_lite_wvalid,
      s_axi_lite_wready => s_axi_lite_wready,
      s_axi_lite_wdata => s_axi_lite_wdata,
      s_axi_lite_bresp => s_axi_lite_bresp,
      s_axi_lite_bvalid => s_axi_lite_bvalid,
      s_axi_lite_bready => s_axi_lite_bready,
      s_axi_lite_arvalid => s_axi_lite_arvalid,
      s_axi_lite_arready => s_axi_lite_arready,
      s_axi_lite_araddr => s_axi_lite_araddr,
      s_axi_lite_rvalid => s_axi_lite_rvalid,
      s_axi_lite_rready => s_axi_lite_rready,
      s_axi_lite_rdata => s_axi_lite_rdata,
      s_axi_lite_rresp => s_axi_lite_rresp,
      m_axi_m2icap_aclk => m_axi_m2icap_aclk,
      m_axi_m2icap_araddr => m_axi_m2icap_araddr,
      m_axi_m2icap_arlen => m_axi_m2icap_arlen,
      m_axi_m2icap_arsize => m_axi_m2icap_arsize,
      m_axi_m2icap_arburst => m_axi_m2icap_arburst,
      m_axi_m2icap_arprot => m_axi_m2icap_arprot,
      m_axi_m2icap_arcache => m_axi_m2icap_arcache,
      m_axi_m2icap_aruser => m_axi_m2icap_aruser,
      m_axi_m2icap_arvalid => m_axi_m2icap_arvalid,
      m_axi_m2icap_arready => m_axi_m2icap_arready,
      m_axi_m2icap_rdata => m_axi_m2icap_rdata,
      m_axi_m2icap_rresp => m_axi_m2icap_rresp,
      m_axi_m2icap_rlast => m_axi_m2icap_rlast,
      m_axi_m2icap_rvalid => m_axi_m2icap_rvalid,
      m_axi_m2icap_rready => m_axi_m2icap_rready,
      icap_intr_out => icap_intr_out
    );

end architecture STRUCTURE;

