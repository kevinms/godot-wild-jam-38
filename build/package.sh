#!/bin/bash

name="sol_runner"

rm ${name}_linux.tar.gz
rm ${name}_windows.zip
rm ${name}_html.zip

(cd linux; tar -cvzf ../${name}_linux.tar.gz *)
(cd windows; zip ../${name}_windows.zip *)
(cd html; zip ../${name}_html.zip *)
