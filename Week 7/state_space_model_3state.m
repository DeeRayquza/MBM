function F = state_space_model_3state(what)
% y = state_space_model_3state('fit_all_ts')

switch what
    case 'fit_all_ts'
        load('T.mat');
        D = T;
        T = [];
        M.A = [0.7 0.99 0.9];   % Add the third state A value
        M.B = [0.15 0.02 0.1];  % Add the third state B value
        M.z0 = [0 0 0 0 0 0 0 0];
        M.LB = [0 0 -1 -1 ]';
        M.UB = [1 1 1 1 ]';
        for s = 1:max(D.SN)
            this = find(D.SN == s);
            Ds = getrow(D, this);
            N = length(Ds.u);
            zf = M.z0;
            zs = M.z0;
            zt = M.z0;  % Add initialization for the third state
            for n = 1:N-1
                y(n,1) = -zf(n,Ds.targetnum(n))-zs(n,Ds.targetnum(n))-zt(n,Ds.targetnum(n));  % Update the y equation
                zf(n+1,:) = zf(n,:);
                zs(n+1,:) = zs(n,:);
                zt(n+1,:) = zt(n,:);  % Update the zt update equation
                if isnan(Ds.u(n))
                    zf(n+1,Ds.targetnum(n)) = M.A(1)*zf(n,Ds.targetnum(n));
                    zs(n+1,Ds.targetnum(n)) = M.A(2)*zs(n,Ds.targetnum(n));
                    zt(n+1,Ds.targetnum(n)) = M.A(3)*zt(n,Ds.targetnum(n));  % Add the third state update equation
                elseif Ds.feedback(n) == 0
                    zf(n+1,Ds.targetnum(n)) = M.A(1)*zf(n,Ds.targetnum(n));
                    zs(n+1,Ds.targetnum(n)) = M.A(2)*zs(n,Ds.targetnum(n));
                    zt(n+1,Ds.targetnum(n)) = M.A(3)*zt(n,Ds.targetnum(n));  % Add the third state update equation
                else
                    zf(n+1,Ds.targetnum(n)) = M.A(1)*zf(n,Ds.targetnum(n)) + M.B(1)*(Ds.u(n)-zf(n,Ds.targetnum(n))-zs(n,Ds.targetnum(n))-zt(n,Ds.targetnum(n)));
                    zs(n+1,Ds.targetnum(n)) = M.A(2)*zs(n,Ds.targetnum(n)) + M.B(2)*(Ds.u(n)-zf(n,Ds.targetnum(n))-zs(n,Ds.targetnum(n))-zt(n,Ds.targetnum(n)));
                    zt(n+1,Ds.targetnum(n)) = M.A(3)*zt(n,Ds.targetnum(n)) + M.B(3)*(Ds.u(n)-zf(n,Ds.targetnum(n))-zs(n,Ds.targetnum(n))-zt(n,Ds.targetnum(n)));  % Add the third state update equation
                end
            end
            y(N,1) = -zf(N,Ds.targetnum(N))-zs(N,Ds.targetnum(N))-zt(N,Ds.targetnum(N));  % Update the y equation
            z = [mean(zf,2) mean(zs,2) mean(zt,2)];  % Update the z matrix
            if M.A(1) > M.A(2)
                M.A = fliplr(M.A);
                M.B = fliplr(M.B);
                z = fliplr(z);
            end
            F(s).A = M.A;
            F(s).B = M.B;
            F(s).z0 = M.z0;
            F(s).yp = y;
            F(s).state_fast = z(:,1);
            F(s).state_slow1 = z(:,2);
            F(s).state_slow2 = z(:,3);  % Add the third state
            F(s).D = Ds;
            F(s).y = Ds.delta_y;
        end
        varargout = {F};
end
