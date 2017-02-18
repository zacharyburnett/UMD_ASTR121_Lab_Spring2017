A = [1:3:7;2 5 8];
B = 10:0.1:50;
C = linspace(10,50,1900);
D = 5*cos(B);
E = 3*(sin(C)).^2;
hold on
plot(B,D,'b-')
plot(C,E,'k--')
xlabel('Incremental Values from 10 to 50');
ylabel('Output values for 2 eqns');
title('Output of two functions, 5cos(x) and 3sin^2(y)')
hold off
G = problem6(B);
figure
plot(B,G,'r')
set(gca, 'xdir','reverse');
xlabel('Incremental Values 10 to 50 (steps of 0.1)')
ylabel('Output from function in prob. 6')
title('Plot of the function in problem 6 from 10 to 50');

