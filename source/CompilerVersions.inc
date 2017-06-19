{$IFDEF VER80}
  {$DEFINE Delphi1}
  {$DEFINE Delphi1up}
{$ELSE}
  {$IFDEF VER90}
    {$DEFINE Delphi2}
    {$DEFINE Delphi2up}
  {$ELSE}
    {$IFDEF VER100}
      {$DEFINE Delphi3}
      {$DEFINE Delphi3up}
    {$ELSE}
      {$IFDEF VER120}
        {$DEFINE Delphi4}
        {$DEFINE Delphi4up}
      {$ELSE}
        {$IFDEF VER130}
          {$DEFINE Delphi5}
          {$DEFINE Delphi5up}
        {$ELSE}
          {$IFDEF VER140}
            {$DEFINE Delphi6}
            {$DEFINE Delphi6up}
          {$ELSE}
            {$IFDEF VER150}
              {$DEFINE Delphi7}
              {$DEFINE Delphi7up}
            {$ELSE}
              {$IFDEF VER170}
                {$DEFINE Delphi2005}
                {$DEFINE Delphi2005up}
              {$ELSE}
                {$IFDEF VER180}
                  {$DEFINE Delphi2006}
                  {$DEFINE Delphi2006up}
                {$ELSE}
                  {$IFDEF VER200}
                    {$DEFINE Delphi2009}
                    {$DEFINE Delphi2009up}
                  {$ELSE}
                    {$IFDEF VER210}
                      {$DEFINE Delphi2010}
                      {$DEFINE Delphi2010up}
                    {$ELSE}
                      {$IFDEF VER220}
                        {$DEFINE DelphiXE}
                        {$DEFINE DelphiXEup}
                      {$ELSE}
                        {$IFDEF VER230}
                          {$DEFINE DelphiXE2}
                          {$DEFINE DelphiXE2up}
                        {$ELSE}
                          {$IFDEF VER240}
                            {$DEFINE DelphiXE3}
                            {$DEFINE DelphiXE3up}
                          {$ELSE}
                            {$IFDEF VER250}
                              {$DEFINE DelphiXE4}
                              {$DEFINE DelphiXE4up}
                            {$ELSE}
                              {$IFDEF VER260}
                                {$DEFINE DelphiXE5}
                                {$DEFINE DelphiXE5up}
                              {$ELSE}
                                {$IFDEF VER270}
                                  {$DEFINE DelphiXE6}
                                  {$DEFINE DelphiXE6up}
                                {$ELSE}
                                  {$IFDEF VER280}
                                    {$DEFINE DelphiXE7}
                                    {$DEFINE DelphiXE7up}
                                  {$ELSE}
                                    {$IFDEF VER290}
                                      {$DEFINE DelphiXE8}
                                      {$DEFINE DelphiXE8up}
                                    {$ELSE}
                                      {$IFDEF VER300}
                                        {$DEFINE Delphi10Seattle}
                                        {$DEFINE Delphi10SeattleUp}
                                      {$ELSE}
                                        {$IFDEF VER310}
                                          {$DEFINE Delphi10Berlin}
                                          {$DEFINE Delphi10BerlinUp}
                                        {$ELSE}
                                          {$IFDEF VER330}
                                            {$DEFINE Delphi10Tokyo}
                                            {$DEFINE Delphi10TokyoUp}
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

