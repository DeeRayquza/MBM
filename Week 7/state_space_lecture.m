function varargout = state_space_lecture(what,varargin)
% y= state_space_lecture('fit_all_ss')
% y= state_space_lecture('fit_all_ts')

switch (what)              
    case 'fit_all_ss' 
        load ('T.mat')
        D=T;     
        T=[];                      
        M.A=0.95;
        M.B=0.2;
        M.z0=[0 0 0 0 0 0 0 0];           
        M.LB=[-1 -1]';  
        M.UB=[1  1]';           
        for s=1      
            this=find(D.SN==s);                                                         
            D=getrow(D,this); 
            N=length(D.u); 
            z=M.z0;                  
            for n=1:N-1 
                y(n,1)=-z(n,D.targetnum(n));
                z(n+1,:)=z(n,:); 
              if isnan(D.u(n))  
                z(n+1,D.targetnum(n))=M.A*z(n,D.targetnum(n));  
              elseif (D.feedback(n)==0)        
                z(n+1,D.targetnum(n))=M.A*z(n,D.targetnum(n));  
              else
                z(n+1,D.targetnum(n))=M.A*z(n,D.targetnum(n))+ M.B * (D.u(n) - z(n, D.targetnum(n)));    
              end
            end; 
            y(N,1)=-z(N,D.targetnum(N));            
            F.A=M.A;
            F.B=M.B;
            F.z0=M.z0;
            F.yp=y;
            F.z=z;
            F.D=D;
            F.y=D.delta_y;
            
            % Plot the data
            figure;
            subplot(2, 1, 1);
            plot(y, 'b', 'LineWidth', 2);
            hold on;
            plot(D.delta_y, 'r--', 'LineWidth', 2);
            legend('Model Predicted Data (yp)', 'Raw Data (y)');
            xlabel('Time');
            ylabel('Position');
            title('Raw Data vs. Model Predicted Data');

            subplot(2, 1, 2);
            plot(z(:, D.targetnum), 'LineWidth', 2);
            legend('State');
            xlabel('Time');
            ylabel('State');
            title('State');
        end                 
        varargout={F};                  

    case 'fit_all_ts'  
        load ('T.mat')
        D=T;     
        T=[];        
        M.A=[0.8 0.99];
        M.B=[0.15 0.02];
        M.z0=[0 0 0 0 0 0 0 0];        
        M.LB=[0 0 -1 -1 ]';  
        M.UB=[1 1  1  1 ]';                       
        for s=1       
            this=find(D.SN==s);                                  
            D=getrow(D,this); 
            N=length(D.u); 
            zf=M.z0;
            zs=M.z0;                
            for n=1:N-1 
                y(n,1)=-zf(n,D.targetnum(n))-zs(n,D.targetnum(n));
                zf(n+1,:)=zf(n,:);
                zs(n+1,:)=zs(n,:);
              if isnan(D.u(n)) 
                zf(n+1,D.targetnum(n))=M.A(1)*zf(n,D.targetnum(n));  
                zs(n+1,D.targetnum(n))=M.A(2)*zs(n,D.targetnum(n));  
              elseif (D.feedback(n)==0)         
                zf(n+1,D.targetnum(n))=M.A(1)*zf(n,D.targetnum(n));  
                zs(n+1,D.targetnum(n))=M.A(2)*zs(n,D.targetnum(n));  
              else 
                %zf(n+1,D.targetnum(n))=M.A(2)*zs(n,D.targetnum(n))+M.B(2)*(D.u(n)-zf(n,D.targetnum(n))-zs(n,D.targetnum(n))); %   
                zf(n+1,D.targetnum(n))=M.A(1)*zf(n,D.targetnum(n))+M.B(1)*(D.u(n)-zf(n,D.targetnum(n))-zs(n,D.targetnum(n))); % Fast system
                zs(n+1,D.targetnum(n))=M.A(2)*zs(n,D.targetnum(n))+M.B(2)*(D.u(n)-zf(n,D.targetnum(n))-zs(n,D.targetnum(n))); % Slow system 
              end
            end
            y(N,1)=-zf(N,D.targetnum(N))-zs(N,D.targetnum(N));
            z = [mean(zf,2) mean(zs,2)];           
            if (M.A(1)>M.A(2)) 
                M.A=fliplr(M.A); 
                M.B=fliplr(M.B);
                z=fliplr(z);
            end 
            F.A=M.A;
            F.B=M.B;
            F.z0=M.z0;
            F.yp=y;
            F.state_fast=z(:,1);
            F.state_slow=z(:,2);
            F.D=D;
            F.y=D.delta_y;   
            
            % Plot the data
            figure;
            subplot(2, 1, 1);
            plot(y, 'b', 'LineWidth', 2);
            hold on;
            plot(D.delta_y, 'r--', 'LineWidth', 2);
            legend('Model Predicted Data (yp)', 'Raw Data (y)');
            xlabel('Time');
            ylabel('Position');
            title('Raw Data vs. Model Predicted Data');

            subplot(2, 1, 2);
            plot(z(:, 1), 'b', 'LineWidth', 2);
            hold on;
            plot(z(:, 2), 'r--', 'LineWidth', 2);
            legend('Fast System (state_fast)', 'Slow System (state_slow)');
            xlabel('Time');
            ylabel('State');
            title('Fast System Output vs. Slow System Output');
        end 
        varargout={F};  
end

% Code for plotting predictions against raw data
load('T.mat');
F = state_space_lecture('fit_all_ts');

figure;
hold on;
for s = 1:max(F.D.SN)
    this = find(F.D.SN == s);
    subplot(2,2,s);
    plot(F.D.delta_y(this),'k-','LineWidth',2);
    hold on;
    plot(F.yp(this),'r--','LineWidth',1.5);
    xlabel('Trial');
    ylabel('Error');
    legend('Raw Data','Model Prediction');
    title(['Subject ',num2str(s)]);
    hold off;
end
