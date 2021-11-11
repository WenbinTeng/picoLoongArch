`default_nettype none

module thinpad_top(
    input wire clk_50M,           //50MHz 时钟输入
    input wire clk_11M0592,       //11.0592MHz 时钟输入（备用，可不用）

    input wire clock_btn,         //BTN5手动时钟按钮�??关，带消抖电路，按下时为1
    input wire reset_btn,         //BTN6手动复位按钮�??关，带消抖电路，按下时为1

    input  wire[3:0]  touch_btn,  //BTN1~BTN4，按钮开关，按下时为1
    input  wire[31:0] dip_sw,     //32位拨码开关，拨到“ON”时�??1
    output wire[15:0] leds,       //16位LED，输出时1点亮
    output wire[7:0]  dpy0,       //数码管低位信号，包括小数点，输出1点亮
    output wire[7:0]  dpy1,       //数码管高位信号，包括小数点，输出1点亮

    //BaseRAM信号
    inout wire[31:0] base_ram_data,  //BaseRAM数据，低8位与CPLD串口控制器共�??
    output wire[19:0] base_ram_addr, //BaseRAM地址
    output wire[3:0] base_ram_be_n,  //BaseRAM字节使能，低有效。如果不使用字节使能，请保持�??0
    output wire base_ram_ce_n,       //BaseRAM片�?�，低有�??
    output wire base_ram_oe_n,       //BaseRAM读使能，低有�??
    output wire base_ram_we_n,       //BaseRAM写使能，低有�??

    //ExtRAM信号
    inout wire[31:0] ext_ram_data,  //ExtRAM数据
    output wire[19:0] ext_ram_addr, //ExtRAM地址
    output wire[3:0] ext_ram_be_n,  //ExtRAM字节使能，低有效。如果不使用字节使能，请保持�??0
    output wire ext_ram_ce_n,       //ExtRAM片�?�，低有�??
    output wire ext_ram_oe_n,       //ExtRAM读使能，低有�??
    output wire ext_ram_we_n,       //ExtRAM写使能，低有�??

    //直连串口信号
    output wire txd,  //直连串口发�?�端
    input  wire rxd,  //直连串口接收�??

    //Flash存储器信号，参�?? JS28F640 芯片手册
    output wire [22:0]flash_a,      //Flash地址，a0仅在8bit模式有效�??16bit模式无意�??
    inout  wire [15:0]flash_d,      //Flash数据
    output wire flash_rp_n,         //Flash复位信号，低有效
    output wire flash_vpen,         //Flash写保护信号，低电平时不能擦除、烧�??
    output wire flash_ce_n,         //Flash片�?�信号，低有�??
    output wire flash_oe_n,         //Flash读使能信号，低有�??
    output wire flash_we_n,         //Flash写使能信号，低有�??
    output wire flash_byte_n,       //Flash 8bit模式选择，低有效。在使用flash�??16位模式时请设�??1

    //图像输出信号
    output wire[2:0] video_red,    //红色像素�??3�??
    output wire[2:0] video_green,  //绿色像素�??3�??
    output wire[1:0] video_blue,   //蓝色像素�??2�??
    output wire video_hsync,       //行同步（水平同步）信�??
    output wire video_vsync,       //场同步（垂直同步）信�??
    output wire video_clk,         //像素时钟输出
    output wire video_de           //行数据有效信号，用于区分消隐�??
);

    wire[7:0] led_bits;
    assign leds = {8'b0, led_bits};
    
    reg [7:0] old_num;
    reg [7:0] new_num;
    
    always @(posedge clk_50M) begin
        if (!reset_btn) begin
            new_num <= 0;
        end
        else begin
            new_num <= dip_sw[7:0];
        end
    end
    
    always @(posedge clk_50M) begin
        if (!reset_btn) begin
            old_num <= 0;
        end
        else begin
            old_num <= new_num;
        end
    end
    
    cpu u_cpu (
        .clk (clk_50M),
        .rst (reset_btn & !(old_num != dip_sw[7:0])),
        .num (dip_sw[7:0]),
        .led (led_bits)
    );

//    /* =========== Demo code begin =========== */
    
//    // PLL��Ƶʾ��
//    wire locked, clk_10M, clk_20M;
//    pll_example clock_gen 
//     (
//      // Clock in ports
//      .clk_in1(clk_50M),  // �ⲿʱ������
//      // Clock out ports
//      .clk_out1(clk_10M), // ʱ�����1��Ƶ����IP���ý���������
//      .clk_out2(clk_20M), // ʱ�����2��Ƶ����IP���ý���������
//      // Status and control signals
//      .reset(reset_btn), // PLL��λ����
//      .locked(locked)    // PLL����ָʾ�����"1"��ʾʱ���ȶ���
//                         // �󼶵�·��λ�ź�Ӧ���������ɣ����£�
//     );
    
//    reg reset_of_clk10M;
//    // �첽��λ��ͬ���ͷţ���locked�ź�תΪ�󼶵�·�ĸ�λreset_of_clk10M
//    always@(posedge clk_10M or negedge locked) begin
//        if(~locked) reset_of_clk10M <= 1'b1;
//        else        reset_of_clk10M <= 1'b0;
//    end
    
//    always@(posedge clk_10M or posedge reset_of_clk10M) begin
//        if(reset_of_clk10M)begin
//            // Your Code
//        end
//        else begin
//            // Your Code
//        end
//    end
    
//    // ��ʹ���ڴ桢����ʱ��������ʹ���ź�
//    assign base_ram_ce_n = 1'b1;
//    assign base_ram_oe_n = 1'b1;
//    assign base_ram_we_n = 1'b1;
    
//    assign ext_ram_ce_n = 1'b1;
//    assign ext_ram_oe_n = 1'b1;
//    assign ext_ram_we_n = 1'b1;
    
//    // ��������ӹ�ϵʾ��ͼ��dpy1ͬ��
//    // p=dpy0[0] // ---a---
//    // c=dpy0[1] // |     |
//    // d=dpy0[2] // f     b
//    // e=dpy0[3] // |     |
//    // b=dpy0[4] // ---g---
//    // a=dpy0[5] // |     |
//    // f=dpy0[6] // e     c
//    // g=dpy0[7] // |     |
//    //           // ---d---  p
    
//    // 7���������������ʾ����number��16������ʾ�����������
//    wire[7:0] number;
//    SEG7_LUT segL(.oSEG1(dpy0), .iDIG(number[3:0])); //dpy0�ǵ�λ�����
//    SEG7_LUT segH(.oSEG1(dpy1), .iDIG(number[7:4])); //dpy1�Ǹ�λ�����
    
//    reg[15:0] led_bits;
//    assign leds = led_bits;
    
//    always@(posedge clock_btn or posedge reset_btn) begin
//        if(reset_btn)begin //��λ���£�����LEDΪ��ʼֵ
//            led_bits <= 16'h1;
//        end
//        else begin //ÿ�ΰ���ʱ�Ӱ�ť��LEDѭ������
//            led_bits <= {led_bits[14:0],led_bits[15]};
//        end
//    end
    
//    //ֱ�����ڽ��շ�����ʾ����ֱ�������յ��������ٷ��ͳ�ȥ
//    wire [7:0] ext_uart_rx;
//    reg  [7:0] ext_uart_buffer, ext_uart_tx;
//    wire ext_uart_ready, ext_uart_clear, ext_uart_busy;
//    reg ext_uart_start, ext_uart_avai;
        
//    assign number = ext_uart_buffer;
    
//    async_receiver #(.ClkFrequency(50000000),.Baud(9600)) //����ģ�飬9600�޼���λ
//        ext_uart_r(
//            .clk(clk_50M),                       //�ⲿʱ���ź�
//            .RxD(rxd),                           //�ⲿ�����ź�����
//            .RxD_data_ready(ext_uart_ready),  //���ݽ��յ���־
//            .RxD_clear(ext_uart_clear),       //������ձ�־
//            .RxD_data(ext_uart_rx)             //���յ���һ�ֽ�����
//        );
    
//    assign ext_uart_clear = ext_uart_ready; //�յ����ݵ�ͬʱ�������־����Ϊ������ȡ��ext_uart_buffer��
//    always @(posedge clk_50M) begin //���յ�������ext_uart_buffer
//        if(ext_uart_ready)begin
//            ext_uart_buffer <= ext_uart_rx;
//            ext_uart_avai <= 1;
//        end else if(!ext_uart_busy && ext_uart_avai)begin 
//            ext_uart_avai <= 0;
//        end
//    end
//    always @(posedge clk_50M) begin //��������ext_uart_buffer���ͳ�ȥ
//        if(!ext_uart_busy && ext_uart_avai)begin 
//            ext_uart_tx <= ext_uart_buffer;
//            ext_uart_start <= 1;
//        end else begin 
//            ext_uart_start <= 0;
//        end
//    end
    
//    async_transmitter #(.ClkFrequency(50000000),.Baud(9600)) //����ģ�飬9600�޼���λ
//        ext_uart_t(
//            .clk(clk_50M),                  //�ⲿʱ���ź�
//            .TxD(txd),                      //�����ź����
//            .TxD_busy(ext_uart_busy),       //������æ״ָ̬ʾ
//            .TxD_start(ext_uart_start),    //��ʼ�����ź�
//            .TxD_data(ext_uart_tx)        //�����͵�����
//        );
    
//    //ͼ�������ʾ���ֱ���800x600@75Hz������ʱ��Ϊ50MHz
//    wire [11:0] hdata;
//    assign video_red = hdata < 266 ? 3'b111 : 0; //��ɫ����
//    assign video_green = hdata < 532 && hdata >= 266 ? 3'b111 : 0; //��ɫ����
//    assign video_blue = hdata >= 532 ? 2'b11 : 0; //��ɫ����
//    assign video_clk = clk_50M;
//    vga #(12, 800, 856, 976, 1040, 600, 637, 643, 666, 1, 1) vga800x600at75 (
//        .clk(clk_50M), 
//        .hdata(hdata), //������
//        .vdata(),      //������
//        .hsync(video_hsync),
//        .vsync(video_vsync),
//        .data_enable(video_de)
//    );
//    /* =========== Demo code end =========== */

endmodule
