clc;clear;

% read simulation results
dataT = readtable('paraemt_x.csv');
dataTibr = readtable('paraemt_ibr.csv');
dataTld = readtable('paraemt_load.csv');
dataTbus = readtable('paraemt_bus.csv');
dataTibr_epri = readtable('paraemt_ebr.csv');


%% parce the data
clc
systemN = 13;
dt = 50.0e-6;
dr = 200;
tend = 50;

ibr_model = 0; % 0-wecc, 1-epri simple, 2-epri detail

xshift = 0;
yshift = -200;

switch systemN
    case 13
        % 240-bus with EPRI's IBR
        bus_n = 243;
        bus_odr = 6;
        load_n = 137;
        load_odr = 4;
        
        gen_genrou_odr = 18;
        gen_genrou_n = 111;
        exc_sexs_odr = 2;
        exc_sexs_n = 111;
        gov_tgov1_odr = 3;
        gov_tgov1_n = 37;
        gov_hygov_odr = 5;
        gov_hygov_n = 25;
        gov_gast_odr = 4;
        gov_gast_n = 49;
        pss_ieeest_odr = 10;
        pss_ieeest_n = 10;
        
        ibr_n = 91;
        regca_odr = 8;
        reecb_odr = 12;
        repca_odr = 21;
        pll_odr = 3;

        switch ibr_model
            case 0
                ibr_odr = regca_odr + reecb_odr + repca_odr;
            case 1
                ibr_odr = 13;
            case 2
                ibr_odr = 0;
        end
        mvabase_T = readtable('emt_gen_mvabase.csv');
        mvabase = table2array(mvabase_T(2:end,2));      
   
end

% %%
clc;
t = table2array(dataT(2:end,1))*dt*dr;
st = 1;
mac_dt = table2array(dataT(2:end,st+1:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_w = table2array(dataT(2:end,st+2:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_id = table2array(dataT(2:end,st+3:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_iq = table2array(dataT(2:end,st+4:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_ifd = table2array(dataT(2:end,st+5:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_i1d = table2array(dataT(2:end,st+6:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_i1q = table2array(dataT(2:end,st+7:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_i2q = table2array(dataT(2:end,st+8:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_ed = table2array(dataT(2:end,st+9:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_eq = table2array(dataT(2:end,st+10:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_psyd = table2array(dataT(2:end,st+11:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_psyq = table2array(dataT(2:end,st+12:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_psyfd = table2array(dataT(2:end,st+13:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_psy1q = table2array(dataT(2:end,st+14:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_psy1d = table2array(dataT(2:end,st+15:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_psy2q = table2array(dataT(2:end,st+16:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_te = table2array(dataT(2:end,st+17:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));
mac_qe = table2array(dataT(2:end,st+18:gen_genrou_odr:(st+gen_genrou_odr*gen_genrou_n)));

st = 1 + gen_genrou_odr*gen_genrou_n;
sexs_v1 = table2array(dataT(2:end,st+1:exc_sexs_odr:(st+exc_sexs_odr*exc_sexs_n)));
sexs_EFD = table2array(dataT(2:end,st+2:exc_sexs_odr:(st+exc_sexs_odr*exc_sexs_n)));

st = 1 + gen_genrou_odr*gen_genrou_n + exc_sexs_odr*exc_sexs_n;
tgov1_p1 = table2array(dataT(2:end,st+1:gov_tgov1_odr:(st+gov_tgov1_odr*gov_tgov1_n)));
tgov1_p2 = table2array(dataT(2:end,st+2:gov_tgov1_odr:(st+gov_tgov1_odr*gov_tgov1_n)));
tgov1_pm = table2array(dataT(2:end,st+3:gov_tgov1_odr:(st+gov_tgov1_odr*gov_tgov1_n)));

st = 1 + gen_genrou_odr*gen_genrou_n + exc_sexs_odr*exc_sexs_n + gov_tgov1_odr*gov_tgov1_n;
hygov_xe = table2array(dataT(2:end,st+1:gov_hygov_odr:(st+gov_hygov_odr*gov_hygov_n)));
hygov_xc = table2array(dataT(2:end,st+2:gov_hygov_odr:(st+gov_hygov_odr*gov_hygov_n)));
hygov_xg = table2array(dataT(2:end,st+3:gov_hygov_odr:(st+gov_hygov_odr*gov_hygov_n)));
hygov_xq = table2array(dataT(2:end,st+4:gov_hygov_odr:(st+gov_hygov_odr*gov_hygov_n)));
hygov_pm = table2array(dataT(2:end,st+5:gov_hygov_odr:(st+gov_hygov_odr*gov_hygov_n)));

st = 1 + gen_genrou_odr*gen_genrou_n + exc_sexs_odr*exc_sexs_n + gov_tgov1_odr*gov_tgov1_n +gov_hygov_odr*gov_hygov_n;
gast_p1 = table2array(dataT(2:end,st+1:gov_gast_odr:(st+gov_gast_odr*gov_gast_n)));
gast_p2 = table2array(dataT(2:end,st+2:gov_gast_odr:(st+gov_gast_odr*gov_gast_n)));
gast_p3 = table2array(dataT(2:end,st+3:gov_gast_odr:(st+gov_gast_odr*gov_gast_n)));
gast_pm = table2array(dataT(2:end,st+4:gov_gast_odr:(st+gov_gast_odr*gov_gast_n)));

st = 1 + gen_genrou_odr*gen_genrou_n + exc_sexs_odr*exc_sexs_n + gov_tgov1_odr*gov_tgov1_n +gov_hygov_odr*gov_hygov_n +gov_gast_odr*gov_gast_n;
ieeest_y1 = table2array(dataT(2:end,st+1:pss_ieeest_odr:(st+pss_ieeest_odr*pss_ieeest_n)));
ieeest_y2 = table2array(dataT(2:end,st+2:pss_ieeest_odr:(st+pss_ieeest_odr*pss_ieeest_n)));
ieeest_y3 = table2array(dataT(2:end,st+3:pss_ieeest_odr:(st+pss_ieeest_odr*pss_ieeest_n)));
ieeest_y4 = table2array(dataT(2:end,st+4:pss_ieeest_odr:(st+pss_ieeest_odr*pss_ieeest_n)));
ieeest_y5 = table2array(dataT(2:end,st+5:pss_ieeest_odr:(st+pss_ieeest_odr*pss_ieeest_n)));
ieeest_y6 = table2array(dataT(2:end,st+6:pss_ieeest_odr:(st+pss_ieeest_odr*pss_ieeest_n)));
ieeest_y7 = table2array(dataT(2:end,st+7:pss_ieeest_odr:(st+pss_ieeest_odr*pss_ieeest_n)));
ieeest_x1 = table2array(dataT(2:end,st+8:pss_ieeest_odr:(st+pss_ieeest_odr*pss_ieeest_n)));
ieeest_x2 = table2array(dataT(2:end,st+9:pss_ieeest_odr:(st+pss_ieeest_odr*pss_ieeest_n)));
ieeest_vs = table2array(dataT(2:end,st+10:pss_ieeest_odr:(st+pss_ieeest_odr*pss_ieeest_n)));


if ibr_model==1
    st = 1;
    ibr_epri_Ea = table2array(dataTibr_epri(2:end,st+1:ibr_odr:(st+ibr_odr*ibr_n)));
    ibr_epri_Eb = table2array(dataTibr_epri(2:end,st+2:ibr_odr:(st+ibr_odr*ibr_n)));
    ibr_epri_Ec = table2array(dataTibr_epri(2:end,st+3:ibr_odr:(st+ibr_odr*ibr_n)));
    ibr_epri_Idref = table2array(dataTibr_epri(2:end,st+4:ibr_odr:(st+ibr_odr*ibr_n)));
    ibr_epri_Id = table2array(dataTibr_epri(2:end,st+5:ibr_odr:(st+ibr_odr*ibr_n)));
    ibr_epri_Iqref = table2array(dataTibr_epri(2:end,st+6:ibr_odr:(st+ibr_odr*ibr_n)));
    ibr_epri_Iq = table2array(dataTibr_epri(2:end,st+7:ibr_odr:(st+ibr_odr*ibr_n)));
    ibr_epri_Vd = table2array(dataTibr_epri(2:end,st+8:ibr_odr:(st+ibr_odr*ibr_n)));
    ibr_epri_Vq = table2array(dataTibr_epri(2:end,st+9:ibr_odr:(st+ibr_odr*ibr_n)));
    ibr_epri_fpll = table2array(dataTibr_epri(2:end,st+10:ibr_odr:(st+ibr_odr*ibr_n)));
    ibr_epri_Pe = table2array(dataTibr_epri(2:end,st+11:ibr_odr:(st+ibr_odr*ibr_n)));
    ibr_epri_Qe = table2array(dataTibr_epri(2:end,st+12:ibr_odr:(st+ibr_odr*ibr_n)));
    ibr_epri_Vpoi = table2array(dataTibr_epri(2:end,st+13:ibr_odr:(st+ibr_odr*ibr_n)));

end


st = 1;
bus_pll_ze = table2array(dataTbus(2:end,st+1:bus_odr:(bus_odr*bus_n)));
bus_pll_de = table2array(dataTbus(2:end,st+2:bus_odr:(bus_odr*bus_n)));
bus_pll_we = table2array(dataTbus(2:end,st+3:bus_odr:(bus_odr*bus_n)));
bus_vt = table2array(dataTbus(2:end,st+4:bus_odr:(bus_odr*bus_n)));
bus_vtm = table2array(dataTbus(2:end,st+5:bus_odr:(bus_odr*bus_n)));
bus_dvtm = table2array(dataTbus(2:end,st+6:bus_odr:(bus_odr*bus_n)));

load_PL = table2array(dataTld(2:end,3:load_odr:(load_odr*load_n)));
load_QL = table2array(dataTld(2:end,4:load_odr:(load_odr*load_n)));

if ibr_model==0
    st = 1;
    regca_s0 = table2array(dataTibr(2:end,st+1:ibr_odr:(st+ibr_odr*ibr_n)));
    regca_s1 = table2array(dataTibr(2:end,st+2:ibr_odr:(st+ibr_odr*ibr_n)));
    regca_s2 = table2array(dataTibr(2:end,st+3:ibr_odr:(st+ibr_odr*ibr_n)));
    regca_Vmp = table2array(dataTibr(2:end,st+4:ibr_odr:(st+ibr_odr*ibr_n)));
    regca_Vap = table2array(dataTibr(2:end,st+5:ibr_odr:(st+ibr_odr*ibr_n)));
    regca_i1 = table2array(dataTibr(2:end,st+6:ibr_odr:(st+ibr_odr*ibr_n)));
    regca_i2 = table2array(dataTibr(2:end,st+7:ibr_odr:(st+ibr_odr*ibr_n)));
    regca_ip2rr = table2array(dataTibr(2:end,st+8:ibr_odr:(st+ibr_odr*ibr_n)));
    
    reecb_s0 = table2array(dataTibr(2:end,st+9:ibr_odr:(st+ibr_odr*ibr_n)));
    reecb_s1 = table2array(dataTibr(2:end,st+10:ibr_odr:(st+ibr_odr*ibr_n)));
    reecb_s2 = table2array(dataTibr(2:end,st+11:ibr_odr:(st+ibr_odr*ibr_n)));
    reecb_s3 = table2array(dataTibr(2:end,st+12:ibr_odr:(st+ibr_odr*ibr_n)));
    reecb_s4 = table2array(dataTibr(2:end,st+13:ibr_odr:(st+ibr_odr*ibr_n)));
    reecb_s5 = table2array(dataTibr(2:end,st+14:ibr_odr:(st+ibr_odr*ibr_n)));
    reecb_Ipcmd = table2array(dataTibr(2:end,st+15:ibr_odr:(st+ibr_odr*ibr_n)));
    reecb_Iqcmd = table2array(dataTibr(2:end,st+16:ibr_odr:(st+ibr_odr*ibr_n)));
    reecb_Pref = table2array(dataTibr(2:end,st+17:ibr_odr:(st+ibr_odr*ibr_n)));
    reecb_Qref = table2array(dataTibr(2:end,st+18:ibr_odr:(st+ibr_odr*ibr_n)));
    reecb_q2vPI = table2array(dataTibr(2:end,st+19:ibr_odr:(st+ibr_odr*ibr_n)));
    reecb_v2iPI = table2array(dataTibr(2:end,st+20:ibr_odr:(st+ibr_odr*ibr_n)));
    
    repca_s0 = table2array(dataTibr(2:end,st+21:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_s1 = table2array(dataTibr(2:end,st+22:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_s2 = table2array(dataTibr(2:end,st+23:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_s3 = table2array(dataTibr(2:end,st+24:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_s4 = table2array(dataTibr(2:end,st+25:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_s5 = table2array(dataTibr(2:end,st+26:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_s6 = table2array(dataTibr(2:end,st+27:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_Vref = table2array(dataTibr(2:end,st+28:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_Qref = table2array(dataTibr(2:end,st+29:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_Freq_ref = table2array(dataTibr(2:end,st+30:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_Plant_pref = table2array(dataTibr(2:end,st+31:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_LineMW = table2array(dataTibr(2:end,st+32:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_LineMvar = table2array(dataTibr(2:end,st+33:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_LineMVA = table2array(dataTibr(2:end,st+34:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_QVdbout = table2array(dataTibr(2:end,st+35:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_fdbout = table2array(dataTibr(2:end,st+36:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_vq2qPI = table2array(dataTibr(2:end,st+37:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_p2pPI = table2array(dataTibr(2:end,st+38:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_Vf = table2array(dataTibr(2:end,st+39:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_Pe = table2array(dataTibr(2:end,st+40:ibr_odr:(st+ibr_odr*ibr_n)));
    repca_Qe = table2array(dataTibr(2:end,st+41:ibr_odr:(st+ibr_odr*ibr_n)));
end

%% plot
clc;
close all;
flag_sg = 1;
dev_flag = 0;


if ibr_model==0
    figure(1)
    clf;hold on;
    set(gcf, 'Position',  [50+xshift, 750+yshift, 400, 200])
    plot(t,regca_s0.*regca_i2,t,reecb_Ipcmd,'--')
    legend('ip','Ipcmd')
    box on;
    title('ip')


    figure(2)
    clf;hold on;
    set(gcf, 'Position',  [500+xshift, 750+yshift, 400, 200])
    plot(t,regca_s1 + regca_i1,t,reecb_Iqcmd,'--')
    legend('iq','Iqcmd')
    box on;
    title('iq')


    figure(3)
    clf;hold on;
    set(gcf, 'Position',  [950+xshift, 750+yshift, 400, 200])
    plot(t,repca_Pe, t, repca_Plant_pref,'--')
    legend('Pe','Pref')
    box on;
    title('P')


    figure(4)
    clf;hold on;
    set(gcf, 'Position',  [1400+xshift, 750+yshift, 400, 200])
    plot(t,repca_Qe, t, repca_Qref,'--')
    legend('Qe','Qref')
    box on;
    title('Q')


    figure(5)
    clf;hold on;
    set(gcf, 'Position',  [50+xshift, 450+yshift, 400, 200])
    plot(t,bus_pll_we*60)
    box on;
    title('\omega PLL')

    figure(6)
    clf;hold on;
    set(gcf, 'Position',  [500+xshift, 450+yshift, 400, 200])
    plot(t,bus_vtm)
    ylim([0.9 1.15])
    box on;
    title('Vtm')
end


if ibr_model == 1
    figure(1)
    clf;hold on;
    set(gcf, 'Position',  [50+xshift, 750+yshift, 400, 200])
    plot(t,ibr_epri_Ea,t,ibr_epri_Eb,t,ibr_epri_Ec)
    legend('Ea','Eb','Ec')
    box on;
    title('Eabc')
    xlim([0 tend])


    figure(2)
    clf;hold on;
    set(gcf, 'Position',  [500+xshift, 750+yshift, 400, 200])
    plot(t,ibr_epri_Idref,t,ibr_epri_Id)
    legend('Idref','Id')
    box on;
    title('Id')
    xlim([0 tend])


    figure(3)
    clf;hold on;
    set(gcf, 'Position',  [950+xshift, 750+yshift, 400, 200])
    plot(t,ibr_epri_Iqref,t,ibr_epri_Iq)
    legend('Iqref','Iq')
    box on;
    title('Iq')
    xlim([0 tend])


    figure(4)
    clf;hold on;
    set(gcf, 'Position',  [50+xshift, 450+yshift, 400, 200])
    plot(t,ibr_epri_fpll)
    box on;
    title('fpll')
    xlim([0 tend])

    figure(5)
    clf;hold on;
    set(gcf, 'Position',  [500+xshift, 450+yshift, 400, 200])
    plot(t,ibr_epri_Vpoi)
    box on;
    title('V')
    xlim([0 tend])

    figure(6)
    clf;hold on;
    set(gcf, 'Position',  [950+xshift, 450+yshift, 400, 200])
    plot(t,ibr_epri_Pe,t,ibr_epri_Qe)
    legend('Pe','Qe')
    box on;
    title('PQ')
    xlim([0 tend])
end




%%
% flag_sg = 1;
flag_ibr = 1 - flag_sg;


if flag_sg == 1
%     figure(1)
%     clf;hold on;
%     set(gcf, 'Position',  [50, 750, 400, 200])
%     plot(t,mac_dt)
%     box on;
% %     ylim([59.7 60.08])
% %     xlim([0 20])
%     title('\delta')
    
    figure(1)
    clf;hold on;
    set(gcf, 'Position',  [100, 600, 400, 200])
%     plot(t,(mac_w - mac_w(:,1)*ones(1,length(mac_w(1,:))))/2/pi/60)  % relative rotor speed (ref:gen 1)
%     plot(t,mac_w/2/pi/60-1) % rotor speed deviation, pu
%     plot(t,mac_w/2/pi,'b')
    plot(t,mac_w/2/pi)
%     plot(t,bus_pll_we*60,'r')
    box on;
%     ylim([59.7 60.08])
%     ylim([59.9 60.1])
    xlim([0 tend])
    title('\omega')
    
    figure(2)
    clf;hold on;
    set(gcf, 'Position',  [505, 600, 400, 200])
    plot(t,mac_te)
    
    box on;
%     ylim([0 100])
    xlim([0 tend])
    title('pe')
    
    
    
    
    figure(3)
    clf;hold on;
    set(gcf, 'Position',  [910, 600, 400, 200])
    plot(t,sexs_EFD - dev_flag*ones(length(t),1)*sexs_EFD(1,:))
    box on;
    title('EFD')
    xlim([0 tend])
    ylim([0 2.5])

    figure(4)
    clf;hold on;
    set(gcf, 'Position',  [1315, 600, 400, 200])
    plot(t,ieeest_vs)
    box on;
    title('Vs IEEEST')
    xlim([0 tend])
    
    
    figure(5)
    clf;hold on;
    set(gcf, 'Position',  [100, 310, 400, 200])
    plot(t,tgov1_pm - dev_flag*ones(length(t),1)*tgov1_pm(1,:))
    box on;
    title('Pm TGOV1')
%     ylim([0 1.2])
    xlim([0 tend])
    ylim([0 2])
    
    figure(6)
    clf;hold on;
    set(gcf, 'Position',  [505, 310, 400, 200])
    plot(t,hygov_pm - dev_flag*ones(length(t),1)*hygov_pm(1,:))
    box on;
    title('Pm HYGOV')
    xlim([0 tend])
    ylim([0 2])
    
    figure(7)
    clf;hold on;
    set(gcf, 'Position',  [910, 310, 400, 200])
    plot(t,gast_pm - dev_flag*ones(length(t),1)*gast_pm(1,:))
    box on;
    title('Pm GAST')
    xlim([0 tend])
    ylim([0 2])

    figure(10)
    clf;hold on;
    set(gcf, 'Position',  [1315, 310, 400, 200])
    plot(t,mac_qe)
    box on;
%     ylim([59 61])
%     xlim([0 20])
    title('qe')
end



if flag_ibr == 1
    figure(1)
    clf;hold on;
    set(gcf, 'Position',  [50, 750, 400, 200])
    plot(t,regca_s0.*regca_i2,t,reecb_Ipcmd,'--')
    legend('ip','Ipcmd')
    box on;
    title('ip')


    figure(2)
    clf;hold on;
    set(gcf, 'Position',  [500, 750, 400, 200])
    plot(t,regca_s1 + regca_i1,t,reecb_Iqcmd,'--')
    legend('iq','Iqcmd')
    box on;
    title('iq')
    
    
    figure(3)
    clf;hold on;
    set(gcf, 'Position',  [950, 750, 400, 200])
    plot(t,repca_Pe, t, repca_Plant_pref,'--')
    legend('Pe','Pref')
    box on;
    title('P')
    
    
    figure(4)
    clf;hold on;
    set(gcf, 'Position',  [1400, 900, 400, 200])
    plot(t,repca_Qe, t, repca_Qref,'--')
    legend('Qe','Qref')
    box on;
    title('Q')
    
    
    figure(5)
    clf;hold on;
    set(gcf, 'Position',  [50, 450, 400, 200])
    plot(t,pll_we*60)
    box on;
    title('\omega PLL')

end
% 
% 
% figure(100)
% dv = bus_vt - dev_flag*ones(length(t),1)*bus_vt(1,:);
% clf;hold on;
% set(gcf, 'Position',  [1400, 50, 400, 200])
% plot(t,dv)
% box on;
% if dev_flag==1
%     title('Bus voltage mag deviation')
% else
%     title('Bus voltage mag')
% end
% xlim([0 tend])
% % ylim([0.8 1.5])
% ylim([0.88 1.18])
% % ylim([0.94 1.05])
% % ylim([-0.1 1])
% 
% 
% % find(dv(7,:)>0.1)
% 
% 
% 
% figure(101)
% clf;hold on;
% set(gcf, 'Position',  [1400, 290, 400, 200])
% % plot(po.t,po.PL,'k','linewidth',2)
% plot(t,(load_PL  - dev_flag*ones(length(t),1)*load_PL(1,:))*1,'r')
% box on;
% title('PL')
% xlim([0 tend])
% ylim([0 15000])
% 
% 
% figure(102)
% clf;hold on;
% set(gcf, 'Position',  [1400, 500, 400, 200])
% % plot(po.t,po.QL,'k','linewidth',2)
% plot(t,(load_QL - dev_flag*ones(length(t),1)*load_QL(1,:))*1,'r')
% box on;
% title('QL')
% xlim([0 tend])
% ylim([-1000 3000])
% 
% %% plotting currents
% close all;clc;
% 
% figure(1)
% clf;hold on;
% set(gcf, 'Position',  [100, 600, 400, 200])
% plot(t,mac_id - dev_flag*ones(length(t),1)*mac_id(1,:),'r')
% box on;
% title('id')
% ylim([-2 2])
% 
% figure(2)
% clf;hold on;
% set(gcf, 'Position',  [505, 600, 400, 200])
% plot(t,mac_ifd - dev_flag*ones(length(t),1)*mac_ifd(1,:),'r')
% box on;
% title('ifd')
% ylim([-2 2])
% 
% figure(3)
% clf;hold on;
% set(gcf, 'Position',  [910, 600, 400, 200])
% plot(t,mac_i1d - dev_flag*ones(length(t),1)*mac_i1d(1,:),'r')
% box on;
% title('i1d')
% ylim([-2 2])
% 
% figure(4)
% clf;hold on;
% set(gcf, 'Position',  [100, 310, 400, 200])
% plot(t,mac_iq - dev_flag*ones(length(t),1)*mac_iq(1,:),'r')
% box on;
% title('iq')
% ylim([-2 2])
% 
% 
% figure(5)
% clf;hold on;
% set(gcf, 'Position',  [505, 310, 400, 200])
% plot(t,mac_i1q - dev_flag*ones(length(t),1)*mac_i1q(1,:),'r')
% box on;
% title('i1q')
% ylim([-2 2])
% 
% 
% figure(6)
% clf;hold on;
% set(gcf, 'Position',  [910, 310, 400, 200])
% plot(t,mac_i2q - dev_flag*ones(length(t),1)*mac_i2q(1,:),'r')
% box on;
% title('i2q')
% ylim([-2 2])
% 
% figure(7)
% ded = mac_ed - dev_flag*ones(length(t),1)*mac_ed(1,:);
% clf;hold on;
% set(gcf, 'Position',  [1315, 600, 400, 200])
% plot(t,ded,'r')
% box on;
% title('ed')
% ylim([-2 2])
% 
% 
% figure(8)
% clf;hold on;
% set(gcf, 'Position',  [1315, 310, 400, 200])
% plot(t,mac_eq - dev_flag*ones(length(t),1)*mac_eq(1,:),'r')
% box on;
% title('eq')
% ylim([-2 2])
% 
% 
% 
% 
% gen_names = dataT.Properties.VariableNames';
% gen_names(1) = [];
% gen_names = gen_names(1:gen_genrou_odr:end);
% find(ded(2,:)>0.5)
% gen_names(find(ded(2,:)>0.5))
% 
% %%
% clc
% dQ = (load_QL(2,:)-load_QL(1,:))';
% dQ_ranked = sortrows([(1:length(dQ))' abs(dQ) dQ dQ./load_QL(1,:)'], -2);
% Load_names = dataTld.Properties.VariableNames';
% Load_names = Load_names(1:load_odr:end);
% Load_names(dQ_ranked(1:10,1))
% 
% [load_PL(1,dQ_ranked(1:10,1))' load_QL(1,dQ_ranked(1:10,1))']
% 
% % %% droop calc
% % clc
% % 
% % kk = 8501;
% % dp = mac_te - ones(length(t),1)*mac_te(1,:);
% % dp = mean(dp(kk:end,:))';
% % df = (mac_w - ones(length(t),1)*mac_w(1,:))/2/pi/60;
% % df = df(end,:)';
% % 
% % droopgain = -df./dp;
% % 
% % % r_tgov1 = -mean(df(1:13))./(tgov1_pm(end,:)-tgov1_pm(1,:))';
% % % r_hygov = -mean(df(1:13))./(hygov_pm(end,:)-hygov_pm(1,:))';
% % % r_gast = -mean(df(1:13))./(gast_pm(end,:)-gast_pm(1,:))';
% % r_tgov1 = 0.003166666666667./(tgov1_pm(end,:)-tgov1_pm(1,:))';
% % r_hygov = 0.003166666666667./(hygov_pm(end,:)-hygov_pm(1,:))';
% % r_gast = 0.003166666666667./(gast_pm(end,:)-gast_pm(1,:))';
% % 
% % 
% % 
% % % idx = find(abs(droopgain)>0.5);
% % % figure(101)
% % % clf;hold on;
% % % plot(t,mac_te(:,idx(1)))
% % % box on;
% % % title('Te')
% % % 
% % % droopgain(idx)
% % % idx-1
% % % % dp(idx)