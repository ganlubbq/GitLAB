% y=pow(x) calculates the power in the input sequence x
function y=pow(x)
y=x(:)'*x(:)/length(x);

