----------------------------------------------------------------------------
-- Filename:          zycap
-- Version:           1.00.a
-- Description:       Topmost file instantiating the DMA controller and the ICAP macro.
-- Author:            Vipin K
-- 
----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library unisim;
use unisim.vcomponents.all;

library zycap_v1_00_a;
use zycap_v1_00_a.axi_dma_pkg.all;

library axi_sg_v4_03_a;
use axi_sg_v4_03_a.all;

library axi_datamover_v4_02_a;
use axi_datamover_v4_02_a.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.max2;

-------------------------------------------------------------------------------
entity  zycap is
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

 end zycap;
 
 
 architecture implementation of zycap is

    signal   mm2s_prmry_reset_out_n : std_logic;
    signal   m_axis_mm2s_tdata : std_logic_vector (31 downto 0);
    signal   m_axis_mm2s_tvalid : std_logic;
    signal   m_axis_mm2s_tready : std_logic;
    signal   m_axis_mm2s_tlast : std_logic;
 
   component axi_dma is
    generic (
      C_S_AXI_LITE_ADDR_WIDTH : INTEGER;
      C_S_AXI_LITE_DATA_WIDTH : INTEGER;
      C_DLYTMR_RESOLUTION : INTEGER;
      C_PRMRY_IS_ACLK_ASYNC : INTEGER;
      C_INCLUDE_SG : INTEGER;
      C_ENABLE_MULTI_CHANNEL : INTEGER;
      C_SG_INCLUDE_DESC_QUEUE : INTEGER;
      C_SG_INCLUDE_STSCNTRL_STRM : INTEGER;
      C_SG_USE_STSAPP_LENGTH : INTEGER;
      C_SG_LENGTH_WIDTH : INTEGER;
      C_M_AXI_SG_ADDR_WIDTH : INTEGER;
      C_M_AXI_SG_DATA_WIDTH : INTEGER;
      C_M_AXIS_MM2S_CNTRL_TDATA_WIDTH : INTEGER;
      C_S_AXIS_S2MM_STS_TDATA_WIDTH : INTEGER;
      C_INCLUDE_MM2S : INTEGER;
      C_INCLUDE_MM2S_SF : INTEGER;
      C_INCLUDE_MM2S_DRE : INTEGER;
      C_MM2S_BURST_SIZE : INTEGER;
      C_M_AXI_MM2S_ADDR_WIDTH : INTEGER;
      C_M_AXI_MM2S_DATA_WIDTH : INTEGER;
      C_M_AXIS_MM2S_TDATA_WIDTH : INTEGER;
      C_INCLUDE_S2MM : INTEGER;
      C_INCLUDE_S2MM_SF : INTEGER;
      C_INCLUDE_S2MM_DRE : INTEGER;
      C_S2MM_BURST_SIZE : INTEGER;
      C_M_AXI_S2MM_ADDR_WIDTH : INTEGER;
      C_M_AXI_S2MM_DATA_WIDTH : INTEGER;
      C_S_AXIS_S2MM_TDATA_WIDTH : INTEGER;
      C_NUM_S2MM_CHANNELS : INTEGER;
      C_NUM_MM2S_CHANNELS : INTEGER;
      C_FAMILY : STRING;
      C_INSTANCE : STRING
    );
    port (
      s_axi_lite_aclk : in std_logic;
      m_axi_sg_aclk : in std_logic;
      m_axi_mm2s_aclk : in std_logic;
      m_axi_s2mm_aclk : in std_logic;
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
      m_axi_sg_awaddr : out std_logic_vector(C_M_AXI_SG_ADDR_WIDTH-1 downto 0);
      m_axi_sg_awlen : out std_logic_vector(7 downto 0);
      m_axi_sg_awsize : out std_logic_vector(2 downto 0);
      m_axi_sg_awburst : out std_logic_vector(1 downto 0);
      m_axi_sg_awprot : out std_logic_vector(2 downto 0);
      m_axi_sg_awcache : out std_logic_vector(3 downto 0);
      m_axi_sg_awuser : out std_logic_vector(3 downto 0);
      m_axi_sg_awvalid : out std_logic;
      m_axi_sg_awready : in std_logic;
      m_axi_sg_wdata : out std_logic_vector(C_M_AXI_SG_DATA_WIDTH-1 downto 0);
      m_axi_sg_wstrb : out std_logic_vector((C_M_AXI_SG_DATA_WIDTH/8)-1 downto 0);
      m_axi_sg_wlast : out std_logic;
      m_axi_sg_wvalid : out std_logic;
      m_axi_sg_wready : in std_logic;
      m_axi_sg_bresp : in std_logic_vector(1 downto 0);
      m_axi_sg_bvalid : in std_logic;
      m_axi_sg_bready : out std_logic;
      m_axi_sg_araddr : out std_logic_vector(C_M_AXI_SG_ADDR_WIDTH-1 downto 0);
      m_axi_sg_arlen : out std_logic_vector(7 downto 0);
      m_axi_sg_arsize : out std_logic_vector(2 downto 0);
      m_axi_sg_arburst : out std_logic_vector(1 downto 0);
      m_axi_sg_arprot : out std_logic_vector(2 downto 0);
      m_axi_sg_arcache : out std_logic_vector(3 downto 0);
      m_axi_sg_aruser : out std_logic_vector(3 downto 0);
      m_axi_sg_arvalid : out std_logic;
      m_axi_sg_arready : in std_logic;
      m_axi_sg_rdata : in std_logic_vector(C_M_AXI_SG_DATA_WIDTH-1 downto 0);
      m_axi_sg_rresp : in std_logic_vector(1 downto 0);
      m_axi_sg_rlast : in std_logic;
      m_axi_sg_rvalid : in std_logic;
      m_axi_sg_rready : out std_logic;
      m_axi_mm2s_araddr : out std_logic_vector(C_M_AXI_MM2S_ADDR_WIDTH-1 downto 0);
      m_axi_mm2s_arlen : out std_logic_vector(7 downto 0);
      m_axi_mm2s_arsize : out std_logic_vector(2 downto 0);
      m_axi_mm2s_arburst : out std_logic_vector(1 downto 0);
      m_axi_mm2s_arprot : out std_logic_vector(2 downto 0);
      m_axi_mm2s_arcache : out std_logic_vector(3 downto 0);
      m_axi_mm2s_aruser : out std_logic_vector(3 downto 0);
      m_axi_mm2s_arvalid : out std_logic;
      m_axi_mm2s_arready : in std_logic;
      m_axi_mm2s_rdata : in std_logic_vector(C_M_AXI_MM2S_DATA_WIDTH-1 downto 0);
      m_axi_mm2s_rresp : in std_logic_vector(1 downto 0);
      m_axi_mm2s_rlast : in std_logic;
      m_axi_mm2s_rvalid : in std_logic;
      m_axi_mm2s_rready : out std_logic;
      mm2s_prmry_reset_out_n : out std_logic;
      m_axis_mm2s_tdata : out std_logic_vector(C_M_AXIS_MM2S_TDATA_WIDTH-1 downto 0);
      m_axis_mm2s_tkeep : out std_logic_vector((C_M_AXIS_MM2S_TDATA_WIDTH/8)-1 downto 0);
      m_axis_mm2s_tvalid : out std_logic;
      m_axis_mm2s_tready : in std_logic;
      m_axis_mm2s_tlast : out std_logic;
      m_axis_mm2s_tuser : out std_logic_vector(3 downto 0);
      m_axis_mm2s_tid : out std_logic_vector(4 downto 0);
      m_axis_mm2s_tdest : out std_logic_vector(4 downto 0);
      mm2s_cntrl_reset_out_n : out std_logic;
      m_axis_mm2s_cntrl_tdata : out std_logic_vector(C_M_AXIS_MM2S_CNTRL_TDATA_WIDTH-1 downto 0);
      m_axis_mm2s_cntrl_tkeep : out std_logic_vector((C_M_AXIS_MM2S_CNTRL_TDATA_WIDTH/8)-1 downto 0);
      m_axis_mm2s_cntrl_tvalid : out std_logic;
      m_axis_mm2s_cntrl_tready : in std_logic;
      m_axis_mm2s_cntrl_tlast : out std_logic;
      m_axi_s2mm_awaddr : out std_logic_vector(C_M_AXI_S2MM_ADDR_WIDTH-1 downto 0);
      m_axi_s2mm_awlen : out std_logic_vector(7 downto 0);
      m_axi_s2mm_awsize : out std_logic_vector(2 downto 0);
      m_axi_s2mm_awburst : out std_logic_vector(1 downto 0);
      m_axi_s2mm_awprot : out std_logic_vector(2 downto 0);
      m_axi_s2mm_awcache : out std_logic_vector(3 downto 0);
      m_axi_s2mm_awuser : out std_logic_vector(3 downto 0);
      m_axi_s2mm_awvalid : out std_logic;
      m_axi_s2mm_awready : in std_logic;
      m_axi_s2mm_wdata : out std_logic_vector(C_M_AXI_S2MM_DATA_WIDTH-1 downto 0);
      m_axi_s2mm_wstrb : out std_logic_vector((C_M_AXI_S2MM_DATA_WIDTH/8)-1 downto 0);
      m_axi_s2mm_wlast : out std_logic;
      m_axi_s2mm_wvalid : out std_logic;
      m_axi_s2mm_wready : in std_logic;
      m_axi_s2mm_bresp : in std_logic_vector(1 downto 0);
      m_axi_s2mm_bvalid : in std_logic;
      m_axi_s2mm_bready : out std_logic;
      s2mm_prmry_reset_out_n : out std_logic;
      s_axis_s2mm_tdata : in std_logic_vector(C_S_AXIS_S2MM_TDATA_WIDTH-1 downto 0);
      s_axis_s2mm_tkeep : in std_logic_vector((C_S_AXIS_S2MM_TDATA_WIDTH/8)-1 downto 0);
      s_axis_s2mm_tvalid : in std_logic;
      s_axis_s2mm_tready : out std_logic;
      s_axis_s2mm_tlast : in std_logic;
      s_axis_s2mm_tuser : in std_logic_vector(3 downto 0);
      s_axis_s2mm_tid : in std_logic_vector(4 downto 0);
      s_axis_s2mm_tdest : in std_logic_vector(4 downto 0);
      s2mm_sts_reset_out_n : out std_logic;
      s_axis_s2mm_sts_tdata : in std_logic_vector(C_S_AXIS_S2MM_STS_TDATA_WIDTH-1 downto 0);
      s_axis_s2mm_sts_tkeep : in std_logic_vector((C_S_AXIS_S2MM_STS_TDATA_WIDTH/8)-1 downto 0);
      s_axis_s2mm_sts_tvalid : in std_logic;
      s_axis_s2mm_sts_tready : out std_logic;
      s_axis_s2mm_sts_tlast : in std_logic;
      mm2s_introut : out std_logic;
      s2mm_introut : out std_logic;
      axi_dma_tstvec : out std_logic_vector(31 downto 0)
    );
  end component;
  
  component icap_ctrl is 
    port(
      ACLK     : in std_logic;
      ARESETN  : in std_logic;
      S_AXIS_TREADY : out std_logic;
      S_AXIS_TDATA : in std_logic_vector(31 downto 0);
      S_AXIS_TLAST : in std_logic;
      S_AXIS_TVALID : in std_logic
     ); 
  end component;     

begin

  axi_dma_0 : axi_dma
    generic map (
      C_S_AXI_LITE_ADDR_WIDTH => 10,
      C_S_AXI_LITE_DATA_WIDTH => 32,
      C_DLYTMR_RESOLUTION => 125,
      C_PRMRY_IS_ACLK_ASYNC => 0,
      C_INCLUDE_SG => 0,
      C_ENABLE_MULTI_CHANNEL => 0,
      C_SG_INCLUDE_DESC_QUEUE => 0,
      C_SG_INCLUDE_STSCNTRL_STRM => 1,
      C_SG_USE_STSAPP_LENGTH => 1,
      C_SG_LENGTH_WIDTH => 23,
      C_M_AXI_SG_ADDR_WIDTH => 32,
      C_M_AXI_SG_DATA_WIDTH => 32,
      C_M_AXIS_MM2S_CNTRL_TDATA_WIDTH => 32,
      C_S_AXIS_S2MM_STS_TDATA_WIDTH => 32,
      C_INCLUDE_MM2S => 1,
      C_INCLUDE_MM2S_SF => 0,
      C_INCLUDE_MM2S_DRE => 0,
      C_MM2S_BURST_SIZE => 256,
      C_M_AXI_MM2S_ADDR_WIDTH => 32,
      C_M_AXI_MM2S_DATA_WIDTH => 32,
      C_M_AXIS_MM2S_TDATA_WIDTH => 32,
      C_INCLUDE_S2MM => 0,
      C_INCLUDE_S2MM_SF => 1,
      C_INCLUDE_S2MM_DRE => 0,
      C_S2MM_BURST_SIZE => 16,
      C_M_AXI_S2MM_ADDR_WIDTH => 32,
      C_M_AXI_S2MM_DATA_WIDTH => 32,
      C_S_AXIS_S2MM_TDATA_WIDTH => 32,
      C_NUM_S2MM_CHANNELS => 1,
      C_NUM_MM2S_CHANNELS => 1,
      C_FAMILY => "zynq",
      C_INSTANCE => "axi_dma_0"
    )
    port map (
      s_axi_lite_aclk => s_axi_lite_aclk,
      m_axi_sg_aclk => s_axi_lite_aclk,
      m_axi_mm2s_aclk => m_axi_m2icap_aclk,
      m_axi_s2mm_aclk => s_axi_lite_aclk,
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
      m_axi_sg_awaddr => open,
      m_axi_sg_awlen => open,
      m_axi_sg_awsize => open,
      m_axi_sg_awburst => open,
      m_axi_sg_awprot => open,
      m_axi_sg_awcache => open,
      m_axi_sg_awuser => open,
      m_axi_sg_awvalid => open,
      m_axi_sg_awready => '0',
      m_axi_sg_wdata => open,
      m_axi_sg_wstrb => open,
      m_axi_sg_wlast => open,
      m_axi_sg_wvalid => open,
      m_axi_sg_wready => '0',
      m_axi_sg_bresp => (others => '0'),
      m_axi_sg_bvalid => '0',
      m_axi_sg_bready => open,
      m_axi_sg_araddr => open,
      m_axi_sg_arlen => open,
      m_axi_sg_arsize => open,
      m_axi_sg_arburst => open,
      m_axi_sg_arprot => open,
      m_axi_sg_arcache => open,
      m_axi_sg_aruser => open,
      m_axi_sg_arvalid => open,
      m_axi_sg_arready => '0',
      m_axi_sg_rdata => (others => '0'),
      m_axi_sg_rresp => (others => '0'),
      m_axi_sg_rlast => '0',
      m_axi_sg_rvalid => '0',
      m_axi_sg_rready => open,
      m_axi_mm2s_araddr => m_axi_m2icap_araddr,
      m_axi_mm2s_arlen => m_axi_m2icap_arlen,
      m_axi_mm2s_arsize => m_axi_m2icap_arsize,
      m_axi_mm2s_arburst => m_axi_m2icap_arburst,
      m_axi_mm2s_arprot => m_axi_m2icap_arprot,
      m_axi_mm2s_arcache => m_axi_m2icap_arcache,
      m_axi_mm2s_aruser => m_axi_m2icap_aruser,
      m_axi_mm2s_arvalid => m_axi_m2icap_arvalid,
      m_axi_mm2s_arready => m_axi_m2icap_arready,
      m_axi_mm2s_rdata => m_axi_m2icap_rdata,
      m_axi_mm2s_rresp => m_axi_m2icap_rresp,
      m_axi_mm2s_rlast => m_axi_m2icap_rlast,
      m_axi_mm2s_rvalid => m_axi_m2icap_rvalid,
      m_axi_mm2s_rready => m_axi_m2icap_rready,
      mm2s_prmry_reset_out_n => mm2s_prmry_reset_out_n,
      m_axis_mm2s_tdata => m_axis_mm2s_tdata,
      m_axis_mm2s_tkeep => open,
      m_axis_mm2s_tvalid => m_axis_mm2s_tvalid,
      m_axis_mm2s_tready => m_axis_mm2s_tready,
      m_axis_mm2s_tlast => m_axis_mm2s_tlast,
      m_axis_mm2s_tuser => open,
      m_axis_mm2s_tid => open,
      m_axis_mm2s_tdest => open,
      mm2s_cntrl_reset_out_n => open,
      m_axis_mm2s_cntrl_tdata => open,
      m_axis_mm2s_cntrl_tkeep => open,
      m_axis_mm2s_cntrl_tvalid => open,
      m_axis_mm2s_cntrl_tready => '0',
      m_axis_mm2s_cntrl_tlast => open,
      m_axi_s2mm_awaddr => open,
      m_axi_s2mm_awlen => open,
      m_axi_s2mm_awsize => open,
      m_axi_s2mm_awburst => open,
      m_axi_s2mm_awprot => open,
      m_axi_s2mm_awcache => open,
      m_axi_s2mm_awuser => open,
      m_axi_s2mm_awvalid => open,
      m_axi_s2mm_awready => '0',
      m_axi_s2mm_wdata => open,
      m_axi_s2mm_wstrb => open,
      m_axi_s2mm_wlast => open,
      m_axi_s2mm_wvalid => open,
      m_axi_s2mm_wready => '0',
      m_axi_s2mm_bresp => (others => '0'),
      m_axi_s2mm_bvalid => '0',
      m_axi_s2mm_bready => open,
      s2mm_prmry_reset_out_n => open,
      s_axis_s2mm_tdata => (others => '0'),
      s_axis_s2mm_tkeep => (others => '0'),
      s_axis_s2mm_tvalid => '0',
      s_axis_s2mm_tready => open,
      s_axis_s2mm_tlast => '0',
      s_axis_s2mm_tuser => (others => '0'),
      s_axis_s2mm_tid => (others => '0'),
      s_axis_s2mm_tdest => (others => '0'),
      s2mm_sts_reset_out_n => open,
      s_axis_s2mm_sts_tdata =>(others => '0'),
      s_axis_s2mm_sts_tkeep => (others => '0'),
      s_axis_s2mm_sts_tvalid => '0',
      s_axis_s2mm_sts_tready => open,
      s_axis_s2mm_sts_tlast => '0',
      mm2s_introut => icap_intr_out,
      s2mm_introut => open,
      axi_dma_tstvec => open
    );
    
    ictrl : icap_ctrl
    port map(
      ACLK     => s_axi_lite_aclk,
      ARESETN  => mm2s_prmry_reset_out_n,
      S_AXIS_TREADY => m_axis_mm2s_tready,
      S_AXIS_TDATA => m_axis_mm2s_tdata,
      S_AXIS_TLAST => m_axis_mm2s_tlast,
      S_AXIS_TVALID => m_axis_mm2s_tvalid
    );

 end implementation;