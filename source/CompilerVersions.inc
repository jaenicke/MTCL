{$IFDEF VER80}
  {$DEFINE Delphi1}
  {$DEFINE Delphi1up}
{$ELSE}
  {$DEFINE Delphi2up}
  {$IFDEF VER90}
    {$DEFINE Delphi2}
  {$ELSE}
    {$DEFINE Delphi3up}
    {$IFDEF VER100}
      {$DEFINE Delphi3}
    {$ELSE}
      {$DEFINE Delphi4up}
      {$IFDEF VER120}
        {$DEFINE Delphi4}
      {$ELSE}
        {$DEFINE Delphi5up}
        {$IFDEF VER130}
          {$DEFINE Delphi5}
        {$ELSE}
          {$DEFINE Delphi6up}
          {$IFDEF VER140}
            {$DEFINE Delphi6}
          {$ELSE}
            {$DEFINE Delphi7up}
            {$IFDEF VER150}
              {$DEFINE Delphi7}
            {$ELSE}
              {$DEFINE Delphi2005up}
              {$IFDEF VER170}
                {$DEFINE Delphi2005}
              {$ELSE}
                {$DEFINE Delphi2006up}
                {$IFDEF VER180}
                  {$DEFINE Delphi2006}
                {$ELSE}
                  {$DEFINE Delphi2007up}
                  {$IFDEF VER190}
                    {$DEFINE Delphi2007}
                  {$ELSE}
                    {$DEFINE Delphi2009up}
                    {$IFDEF VER200}
                      {$DEFINE Delphi2009}
                    {$ELSE}
                      {$DEFINE Delphi2010up}
                      {$IFDEF VER210}
                        {$DEFINE Delphi2010}
                      {$ELSE}
                        {$DEFINE DelphiXEup}
                        {$IFDEF VER220}
                          {$DEFINE DelphiXE}
                        {$ELSE}
                          {$DEFINE DelphiXE2up}
                          {$IFDEF VER230}
                            {$DEFINE DelphiXE2}
                          {$ELSE}
                            {$DEFINE DelphiXE3up}
                            {$IFDEF VER240}
                              {$DEFINE DelphiXE3}
                            {$ELSE}
                              {$DEFINE DelphiXE4up}
                              {$IFDEF VER250}
                                {$DEFINE DelphiXE4}
                              {$ELSE}
                                {$DEFINE DelphiXE5up}
                                {$IFDEF VER260}
                                  {$DEFINE DelphiXE5}
                                {$ELSE}
                                  {$DEFINE DelphiXE6up}
                                  {$IFDEF VER270}
                                    {$DEFINE DelphiXE6}
                                  {$ELSE}
                                    {$DEFINE DelphiXE7up}
                                    {$IFDEF VER280}
                                      {$DEFINE DelphiXE7}
                                    {$ELSE}
                                      {$DEFINE DelphiXE8up}
                                      {$IFDEF VER290}
                                        {$DEFINE DelphiXE8}
                                      {$ELSE}
                                        {$DEFINE Delphi10SeattleUp}
                                        {$DEFINE Delphi10_0Up}
                                        {$IFDEF VER300}
                                          {$DEFINE Delphi10Seattle}
                                          {$DEFINE Delphi10_0}
                                        {$ELSE}
                                          {$DEFINE Delphi10BerlinUp}
                                          {$DEFINE Delphi10_1Up}
                                          {$IFDEF VER310}
                                            {$DEFINE Delphi10Berlin}
                                            {$DEFINE Delphi10_1}
                                          {$ELSE}
                                            {$DEFINE Delphi10TokyoUp}
                                            {$DEFINE Delphi10_2Up}
                                            {$IFDEF VER320}
                                              {$DEFINE Delphi10Tokyo}
                                              {$DEFINE Delphi10_2}
                                            {$ELSE}
                                              {$DEFINE Delphi10RioUp}
                                              {$DEFINE Delphi10_3Up}
                                              {$IFDEF VER330}
                                                {$DEFINE Delphi10Rio}
                                                {$DEFINE Delphi10_3}
                                              {$ELSE}
                                                {$DEFINE Delphi10SydneyUp}
                                                {$DEFINE Delphi10_4Up}
                                                {$IFDEF VER340}
                                                  {$DEFINE Delphi10Sydney}
                                                  {$DEFINE Delphi10_4}
                                                {$ELSE}
                                                  {$DEFINE Delphi11AlexandriaUp}
                                                  {$DEFINE Delphi11Up}
                                                  {$IFDEF VER350}
                                                    {$DEFINE Delphi11Alexandria}
                                                    {$DEFINE Delphi11}
                                                    {$IF declared(RTLVersion111)}{$IF RTLVersion111}
                                                      {$DEFINE Delphi11_1}
                                                      {$DEFINE Delphi11_1Up}
                                                    {$ENDIF}{$ENDIF}
                                                  {$ELSE}
                                                    {$DEFINE Delphi11_1Up}
                                                  {$ENDIF}
                                                {$ENDIF}
                                              {$ENDIF}
                                            {$ENDIF}
                                          {$ENDIF}
                                        {$ENDIF}
                                      {$ENDIF}
                                    {$ENDIF}
                                  {$ENDIF}
                                {$ENDIF}
                              {$ENDIF}
                            {$ENDIF}
                          {$ENDIF}
                        {$ENDIF}
                      {$ENDIF}
                    {$ENDIF}
                  {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

