function progmeter(currentIndex, total)

if currentIndex==0    
    fprintf(1,'\n');
    fwrite(1,sprintf('00%%'));
    return;
else
    fwrite(1,sprintf('\b\b\b'));
    fwrite(1,sprintf('%02d%%', round(100*currentIndex/total)));
end

if currentIndex==total,
  fprintf(1,'\n');
end
