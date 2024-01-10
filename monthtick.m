function tickout = monthtick(type,leap)

tickout.monthnames = monthnames(1:12,'individual',type);
if leap
    tickout.tick = cumsum([1,29,31,30,31,30,31,30,31,31,30,31]);
else
    tickout.tick = cumsum([1,28,31,30,31,30,31,30,31,31,30,31]);
end

end