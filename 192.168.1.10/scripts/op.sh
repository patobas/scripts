#!/bin/bash
openvassd #(escucha en 9390)
openvasmd --port 9391 --sport 9390 #(escucha en 9391 y conecta a openvassd en 9390)
gsad --mport 9391 -v --http-only
