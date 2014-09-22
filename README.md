Air application source code
ActionScript AS3 FLEX
This example shows how to execute the analysis of an ExcelFile inside a Worker with the Coworker process.


The "Coworker" framework

By Hugues Sansen, Shankaa

Foreword
Flash doesn't offer multi-threading programming. We all miss it. However Flash has introduced many years ago a way
to communicate between Flash applications. Relatively recently, they have offered the possibility to declare workers,
on a very similar mechanism.
Interprocess communication is not as flexible as multi-threading but this is what we have. To offer something almost as
efficient as multi-threading we have developed the coworker framework for our own purpose.

The Coworker framework has been developed to standardize the way a worker communicates with other workers.
The inspiration comes from Android Inter Process Communication framework, a very elegant way for communicating
between applications.
Unfortunately we didn't automate the proxy and stub creation as it is done in AIPC with the AIDL
(Android Interface Description Language). To do so we should integrate some code inside FlashBuilder
So the developer has to create the stubs and proxies himself.



Where do we use Coworker?
We have used this framework widely in Visumag, a Big Data representation application. As you may understand,
we have to do some computation on the client while we display stores in 3D in the main worker. 3D representation is CPU
intensive when we have many thousands shelves with many tens of thousands of products to display.

License
The Coworker framework is provided under the European Union Public Licence (EUPL)

https://joinup.ec.europa.eu/software/page/eupl
